import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../datasources/dashboard_remote_data_source.dart';
import '../../domain/models/activity.dart';
import '../../domain/models/dashboard_stats.dart';
import '../../domain/models/escalation.dart';
import '../../domain/models/incident.dart';
import '../../domain/models/incident_trend.dart';
import '../../domain/models/performance_metrics.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardStats>> getStats() async {
    try {
      final stats = await remoteDataSource.getStats();
      return Right(stats);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          '${e.requestOptions.path}: ${e.message ?? 'Server Error'}',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Incident>>> getIncidents() async {
    try {
      final incidents = await remoteDataSource.getIncidents();
      return Right(incidents);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          '${e.requestOptions.path}: ${e.message ?? 'Server Error'}',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Activity>>> getActivities() async {
    try {
      final activities = await remoteDataSource.getActivities();
      return Right(activities);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          '${e.requestOptions.path}: ${e.message ?? 'Server Error'}',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Escalation>>> getActiveEscalations() async {
    try {
      final escalations = await remoteDataSource.getActiveEscalations();
      return Right(escalations);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          '${e.requestOptions.path}: ${e.message ?? 'Server Error'}',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> acknowledgeEscalation(String alertId) async {
    try {
      await remoteDataSource.acknowledgeEscalation(alertId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          '${e.requestOptions.path}: ${e.message ?? 'Server Error'}',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> triggerEscalation(String alertId) async {
    try {
      await remoteDataSource.triggerEscalation(alertId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          '${e.requestOptions.path}: ${e.message ?? 'Server Error'}',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> stopEscalation() async {
    try {
      await remoteDataSource.stopEscalation();
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          '${e.requestOptions.path}: ${e.message ?? 'Server Error'}',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PerformanceMetrics>> getPerformanceMetrics() async {
    try {
      final metrics = await remoteDataSource.getPerformanceMetrics();
      return Right(metrics);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          '${e.requestOptions.path}: ${e.message ?? 'Server Error'}',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IncidentTrend>>> getIncidentTrends() async {
    try {
      final trends = await remoteDataSource.getIncidentTrends();
      return Right(trends);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          '${e.requestOptions.path}: ${e.message ?? 'Server Error'}',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> exportReportBundle() async {
    try {
      await remoteDataSource.exportReportBundle();
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          '${e.requestOptions.path}: ${e.message ?? 'Server Error'}',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
