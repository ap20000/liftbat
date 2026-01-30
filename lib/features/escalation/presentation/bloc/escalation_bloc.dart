import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/escalation.dart';
import '../../domain/usecases/get_active_escalations.dart';
import 'escalation_event.dart';
import 'escalation_state.dart';

import '../../domain/usecases/acknowledge_escalation.dart';
import '../../domain/usecases/stop_escalation.dart';

class EscalationBloc extends Bloc<EscalationEvent, EscalationState> {
  final GetActiveEscalations getActiveEscalations;
  final AcknowledgeEscalation acknowledgeEscalation;
  final StopEscalation stopEscalation;
  Timer? _pollingTimer;
  Timer? _countdownTimer;

  EscalationBloc({
    required this.getActiveEscalations,
    required this.acknowledgeEscalation,
    required this.stopEscalation,
  }) : super(EscalationInitial()) {
    on<LoadEscalations>(_onLoadEscalations);
    on<UpdateEscalationTimers>(_onUpdateTimers);
    on<AcknowledgeEscalationEvent>(_onAcknowledgeEscalation);
    on<StopEscalationEvent>(_onStopEscalation);

    _startTimers();
  }

  void _startTimers() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      add(LoadEscalations());
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(UpdateEscalationTimers());
    });
  }

  Future<void> _onLoadEscalations(
    LoadEscalations event,
    Emitter<EscalationState> emit,
  ) async {
    if (state is EscalationInitial) {
      emit(EscalationLoading());
    }

    final result = await getActiveEscalations();

    result.fold(
      (failure) {
        if (state is! EscalationLoaded) {
          emit(EscalationError(_mapFailureToMessage(failure)));
        }
      },
      (escalations) {
        // Build map of current statuses to preserve local optimistic updates if needed
        // For now, simpler: server is source of truth, but we could check against current state to prevent overwriting acknowledged status if server is laggy
        emit(
          EscalationLoaded(
            activeEscalations: escalations,
            lastUpdated: DateTime.now(),
          ),
        );
      },
    );
  }

  void _onUpdateTimers(
    UpdateEscalationTimers event,
    Emitter<EscalationState> emit,
  ) {
    if (state is EscalationLoaded) {
      final currentState = state as EscalationLoaded;
      final updatedEscalations = currentState.activeEscalations.map((e) {
        final newRemaining = e.remainingSeconds > 0
            ? e.remainingSeconds - 1
            : 0;
        return Escalation(
          id: e.id,
          title: e.title,
          description: e.description,
          tier: e.tier,
          tierName: e.tierName,
          status: e.status,
          startedAt: e.startedAt,
          timeoutSeconds: e.timeoutSeconds,
          remainingSeconds: newRemaining,
        );
      }).toList();

      emit(
        EscalationLoaded(
          activeEscalations: updatedEscalations,
          lastUpdated: currentState.lastUpdated,
        ),
      );
    }
  }

  Future<void> _onAcknowledgeEscalation(
    AcknowledgeEscalationEvent event,
    Emitter<EscalationState> emit,
  ) async {
    if (state is EscalationLoaded) {
      final currentState = state as EscalationLoaded;
      // Optimistic Update
      final updatedEscalations = currentState.activeEscalations.map((e) {
        if (e.id == event.id) {
          return Escalation(
            id: e.id,
            title: e.title,
            description: e.description,
            tier: e.tier,
            tierName: e.tierName,
            status: 'acknowledged',
            startedAt: e.startedAt,
            timeoutSeconds: e.timeoutSeconds,
            remainingSeconds: e.remainingSeconds,
          );
        }
        return e;
      }).toList();

      emit(
        EscalationLoaded(
          activeEscalations: updatedEscalations,
          lastUpdated: currentState.lastUpdated,
        ),
      );

      emit(
        EscalationLoaded(
          activeEscalations: updatedEscalations,
          lastUpdated: currentState.lastUpdated,
        ),
      );

      await acknowledgeEscalation(event.id);
    }
  }

  Future<void> _onStopEscalation(
    StopEscalationEvent event,
    Emitter<EscalationState> emit,
  ) async {
    if (state is EscalationLoaded) {
      final currentState = state as EscalationLoaded;
      // Optimistic Update: Remove from list
      final updatedEscalations = currentState.activeEscalations
          .where((e) => e.id != event.id)
          .toList();

      emit(
        EscalationLoaded(
          activeEscalations: updatedEscalations,
          lastUpdated: currentState.lastUpdated,
        ),
      );

      await stopEscalation(event.id);
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Error';
      case CacheFailure:
        return 'Cache Error';
      default:
        return 'Unexpected Error';
    }
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    _countdownTimer?.cancel();
    return super.close();
  }
}
