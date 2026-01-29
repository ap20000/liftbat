import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User?>> getAuthenticatedUser();
  Future<Either<Failure, User>> verifyMagicLink(String token);
}
