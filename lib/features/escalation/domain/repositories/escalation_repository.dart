import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/escalation.dart';
import '../entities/escalation_rule.dart';

abstract class EscalationRepository {
  Future<Either<Failure, List<Escalation>>> getActiveEscalations();
  Future<Either<Failure, List<EscalationRule>>> getEscalationRules();
  Future<Either<Failure, void>> acknowledgeEscalation(
    String logId,
    int tierId,
    String acknowledgedBy,
  );
  Future<Either<Failure, void>> skipEscalation(String logId);
  Future<Either<Failure, void>> stopEscalation(String logId);
  Future<Either<Failure, void>> triggerEscalation(
    String alertId,
    Map<String, dynamic> data,
  );
}
