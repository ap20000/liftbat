import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/escalation.dart';
import '../repositories/escalation_repository.dart';

class GetActiveEscalations {
  final EscalationRepository repository;

  GetActiveEscalations(this.repository);

  Future<Either<Failure, List<Escalation>>> call() async {
    return await repository.getActiveEscalations();
  }
}
