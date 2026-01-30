import 'package:equatable/equatable.dart';
import '../../domain/entities/escalation.dart';

abstract class EscalationState extends Equatable {
  const EscalationState();

  @override
  List<Object> get props => [];
}

class EscalationInitial extends EscalationState {}

class EscalationLoading extends EscalationState {}

class EscalationLoaded extends EscalationState {
  final List<Escalation> activeEscalations;
  final DateTime lastUpdated;

  const EscalationLoaded({
    required this.activeEscalations,
    required this.lastUpdated,
  });

  @override
  List<Object> get props => [activeEscalations, lastUpdated];
}

class EscalationError extends EscalationState {
  final String message;

  const EscalationError(this.message);

  @override
  List<Object> get props => [message];
}
