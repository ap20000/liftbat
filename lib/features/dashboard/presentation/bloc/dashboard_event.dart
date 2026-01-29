import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {}

class AcknowledgeEscalationRequested extends DashboardEvent {
  final String alertId;
  const AcknowledgeEscalationRequested(this.alertId);

  @override
  List<Object?> get props => [alertId];
}

class TriggerEscalationRequested extends DashboardEvent {
  final String alertId;
  const TriggerEscalationRequested(this.alertId);

  @override
  List<Object?> get props => [alertId];
}

class StopEscalationRequested extends DashboardEvent {}

class LoadAnalytics extends DashboardEvent {}

class ExportReportRequested extends DashboardEvent {}
