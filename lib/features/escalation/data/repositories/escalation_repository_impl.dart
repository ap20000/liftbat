import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/escalation_remote_data_source.dart';
import '../../domain/entities/escalation.dart';
import '../../domain/entities/escalation_rule.dart';
import '../../domain/repositories/escalation_repository.dart';

class EscalationRepositoryImpl implements EscalationRepository {
  final EscalationRemoteDataSource remoteDataSource;

  EscalationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Escalation>>> getActiveEscalations() async {
    try {
      final remoteEscalations = await remoteDataSource.getActiveEscalations();
      return Right(remoteEscalations);
    } on ServerException {
      return const Left(ServerFailure('Server Failure'));
    }
  }

  @override
  Future<Either<Failure, void>> acknowledgeEscalation(
    String logId,
    int tierId,
    String acknowledgedBy,
  ) async {
    try {
      await remoteDataSource.acknowledgeEscalation(
        logId,
        tierId,
        acknowledgedBy,
      );
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure('Server Failure'));
    }
  }

  @override
  Future<Either<Failure, void>> skipEscalation(String logId) async {
    try {
      await remoteDataSource.skipEscalation(logId);
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure('Server Failure'));
    }
  }

  @override
  Future<Either<Failure, void>> stopEscalation(String logId) async {
    try {
      await remoteDataSource.stopEscalation(logId);
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure('Server Failure'));
    }
  }

  @override
  Future<Either<Failure, List<EscalationRule>>> getEscalationRules() async {
    try {
      final remoteRules = await remoteDataSource.getEscalationRules();
      return Right(remoteRules);
    } on ServerException {
      return const Left(ServerFailure('Server Failure'));
    }
  }

  @override
  Future<Either<Failure, void>> triggerEscalation(
    String alertId,
    Map<String, dynamic> data,
  ) async {
    try {
      await remoteDataSource.triggerEscalation(alertId, data);
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure('Server Failure'));
    }
  }
}
