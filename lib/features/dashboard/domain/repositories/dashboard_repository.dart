import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/activity.dart';
import '../models/dashboard_stats.dart';
import '../models/escalation.dart';
import '../models/incident.dart';
import '../models/incident_trend.dart';
import '../models/performance_metrics.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardStats>> getStats();
  Future<Either<Failure, List<Incident>>> getIncidents();
  Future<Either<Failure, List<Activity>>> getActivities();
  Future<Either<Failure, List<Escalation>>> getActiveEscalations();
  Future<Either<Failure, void>> acknowledgeEscalation(String alertId);
  Future<Either<Failure, void>> triggerEscalation(String alertId);
  Future<Either<Failure, void>> stopEscalation();
  Future<Either<Failure, PerformanceMetrics>> getPerformanceMetrics();
  Future<Either<Failure, List<IncidentTrend>>> getIncidentTrends();
  Future<Either<Failure, void>> exportReportBundle();
}
