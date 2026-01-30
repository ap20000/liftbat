import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/escalation_rule.dart';
import '../../domain/usecases/fetch_escalation_rules.dart';
import '../../domain/usecases/trigger_escalation.dart';

// Events
abstract class ManualEscalationEvent extends Equatable {
  const ManualEscalationEvent();
  @override
  List<Object> get props => [];
}

class LoadEscalationRules extends ManualEscalationEvent {}

class SubmitManualEscalation extends ManualEscalationEvent {
  final Map<String, dynamic> data;
  const SubmitManualEscalation(this.data);
  @override
  List<Object> get props => [data];
}

class SelectEscalationRule extends ManualEscalationEvent {
  final EscalationRule rule;
  const SelectEscalationRule(this.rule);
  @override
  List<Object> get props => [rule];
}

// State
enum ManualEscalationStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  error,
}

class ManualEscalationState extends Equatable {
  final ManualEscalationStatus status;
  final List<EscalationRule> rules;
  final EscalationRule? selectedRule;
  final String? errorMessage;

  const ManualEscalationState({
    this.status = ManualEscalationStatus.initial,
    this.rules = const [],
    this.selectedRule,
    this.errorMessage,
  });

  ManualEscalationState copyWith({
    ManualEscalationStatus? status,
    List<EscalationRule>? rules,
    EscalationRule? selectedRule,
    String? errorMessage,
  }) {
    return ManualEscalationState(
      status: status ?? this.status,
      rules: rules ?? this.rules,
      selectedRule: selectedRule ?? this.selectedRule,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, rules, selectedRule, errorMessage];
}

// Bloc
class ManualEscalationBloc
    extends Bloc<ManualEscalationEvent, ManualEscalationState> {
  final FetchEscalationRules fetchEscalationRules;
  final TriggerEscalation triggerEscalation;

  ManualEscalationBloc({
    required this.fetchEscalationRules,
    required this.triggerEscalation,
  }) : super(const ManualEscalationState()) {
    on<LoadEscalationRules>(_onLoadRules);
    on<SelectEscalationRule>(_onSelectRule);
    on<SubmitManualEscalation>(_onSubmit);
  }

  Future<void> _onLoadRules(
    LoadEscalationRules event,
    Emitter<ManualEscalationState> emit,
  ) async {
    emit(state.copyWith(status: ManualEscalationStatus.loading));
    final result = await fetchEscalationRules();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ManualEscalationStatus.error,
          errorMessage: 'Failed to load rules',
        ),
      ),
      (rules) => emit(
        state.copyWith(status: ManualEscalationStatus.loaded, rules: rules),
      ),
    );
  }

  void _onSelectRule(
    SelectEscalationRule event,
    Emitter<ManualEscalationState> emit,
  ) {
    emit(state.copyWith(selectedRule: event.rule));
  }

  Future<void> _onSubmit(
    SubmitManualEscalation event,
    Emitter<ManualEscalationState> emit,
  ) async {
    emit(state.copyWith(status: ManualEscalationStatus.submitting));
    final alertId = event.data['rule_id']?.toString() ?? 'manual';
    final result = await triggerEscalation(alertId, event.data);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ManualEscalationStatus.error,
          errorMessage: 'Failed to trigger escalation',
        ),
      ),
      (success) => emit(state.copyWith(status: ManualEscalationStatus.success)),
    );
  }
}
