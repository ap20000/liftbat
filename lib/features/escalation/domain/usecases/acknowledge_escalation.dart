import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/escalation_repository.dart';

class AcknowledgeEscalation {
  final EscalationRepository repository;

  AcknowledgeEscalation(this.repository);

  Future<Either<Failure, void>> call(String logId) async {
    // Hardcoding tierId=2 and user='Guard' for now as per MVP requirements or context
    return await repository.acknowledgeEscalation(logId, 2, 'mobile_user');
  }
}
