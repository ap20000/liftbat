import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/escalation_repository.dart';

class StopEscalation {
  final EscalationRepository repository;

  StopEscalation(this.repository);

  Future<Either<Failure, void>> call(String logId) async {
    return await repository.stopEscalation(logId);
  }
}
