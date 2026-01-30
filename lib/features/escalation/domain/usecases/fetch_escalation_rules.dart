import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/escalation_rule.dart';
import '../../domain/repositories/escalation_repository.dart';

class FetchEscalationRules {
  final EscalationRepository repository;

  FetchEscalationRules(this.repository);

  Future<Either<Failure, List<EscalationRule>>> call() async {
    return await repository.getEscalationRules();
  }
}
