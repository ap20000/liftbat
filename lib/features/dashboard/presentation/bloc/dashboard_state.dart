import 'package:equatable/equatable.dart';
import '../../domain/models/activity.dart';
import '../../domain/models/dashboard_stats.dart';
import '../../domain/models/escalation.dart';
import '../../domain/models/incident.dart';
import '../../domain/models/incident_trend.dart';
import '../../domain/models/performance_metrics.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardStats stats;
  final List<Incident> incidents;
  final List<Activity> activities;
  final List<Escalation> activeEscalations;
  final PerformanceMetrics analytics;
  final List<IncidentTrend> trends;

  const DashboardLoaded({
    required this.stats,
    required this.incidents,
    required this.activities,
    required this.activeEscalations,
    required this.analytics,
    required this.trends,
  });

  @override
  List<Object?> get props => [
    stats,
    incidents,
    activities,
    activeEscalations,
    analytics,
    trends,
  ];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
