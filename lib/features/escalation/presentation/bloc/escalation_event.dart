import 'package:equatable/equatable.dart';

abstract class EscalationEvent extends Equatable {
  const EscalationEvent();

  @override
  List<Object> get props => [];
}

class LoadEscalations extends EscalationEvent {}

class UpdateEscalationTimers extends EscalationEvent {}

class AcknowledgeEscalationEvent extends EscalationEvent {
  final String id;
  const AcknowledgeEscalationEvent(this.id);
  @override
  List<Object> get props => [id];
}

class StopEscalationEvent extends EscalationEvent {
  final String id;
  const StopEscalationEvent(this.id);
  @override
  List<Object> get props => [id];
}
