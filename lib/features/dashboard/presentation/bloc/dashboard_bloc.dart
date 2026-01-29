import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/models/activity.dart';
import '../../domain/models/dashboard_stats.dart';
import '../../domain/models/escalation.dart';
import '../../domain/models/incident.dart';
import '../../domain/models/incident_trend.dart';
import '../../domain/models/performance_metrics.dart';
import '../../domain/repositories/dashboard_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;

  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<LoadAnalytics>((event, emit) => _onLoadDashboard(LoadDashboard(), emit));
    on<AcknowledgeEscalationRequested>(_onAcknowledgeEscalation);
    on<TriggerEscalationRequested>(_onTriggerEscalation);
    on<StopEscalationRequested>(_onStopEscalation);
    on<ExportReportRequested>(_onExportReport);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    final results = await Future.wait<dynamic>([
      repository.getStats(),
      repository.getIncidents(),
      repository.getActivities(),
      repository.getActiveEscalations(),
      repository.getPerformanceMetrics(),
      repository.getIncidentTrends(),
    ]);

    final statsResult = results[0] as Either<Failure, DashboardStats>;
    final incidentsResult = results[1] as Either<Failure, List<Incident>>;
    final activitiesResult = results[2] as Either<Failure, List<Activity>>;
    final escalationsResult = results[3] as Either<Failure, List<Escalation>>;
    final analyticsResult = results[4] as Either<Failure, PerformanceMetrics>;
    final trendsResult = results[5] as Either<Failure, List<IncidentTrend>>;

    statsResult.fold(
      (failure) => emit(DashboardError('Stats Error: ${failure.message}')),
      (stats) {
        final incidents = incidentsResult.getOrElse(() => []);
        final activities = activitiesResult.getOrElse(() => []);
        final escalations = escalationsResult.getOrElse(() => []);
        final analytics = analyticsResult.getOrElse(
          () => PerformanceMetrics.empty(),
        );
        final trends = trendsResult.getOrElse(() => []);

        emit(
          DashboardLoaded(
            stats: stats,
            incidents: incidents,
            activities: activities,
            activeEscalations: escalations,
            analytics: analytics,
            trends: trends,
          ),
        );
      },
    );
  }

  Future<void> _onAcknowledgeEscalation(
    AcknowledgeEscalationRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final result = await repository.acknowledgeEscalation(event.alertId);
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (_) => add(LoadDashboard()),
    );
  }

  Future<void> _onTriggerEscalation(
    TriggerEscalationRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final result = await repository.triggerEscalation(event.alertId);
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (_) => add(LoadDashboard()),
    );
  }

  Future<void> _onStopEscalation(
    StopEscalationRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final result = await repository.stopEscalation();
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (_) => add(LoadDashboard()),
    );
  }

  Future<void> _onExportReport(
    ExportReportRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final result = await repository.exportReportBundle();
    result.fold((failure) => emit(DashboardError(failure.message)), (_) {
      // Handle success notification if needed
    });
  }
}
