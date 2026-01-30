import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/escalation_repository.dart';

class TriggerEscalation {
  final EscalationRepository repository;

  TriggerEscalation(this.repository);

  Future<Either<Failure, void>> call(
    String alertId,
    Map<String, dynamic> data,
  ) async {
    return await repository.triggerEscalation(alertId, data);
  }
}
