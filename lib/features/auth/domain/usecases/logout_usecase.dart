import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  Logout({required this.repository});

  Future<Either<Failure, Unit>> call() {
    return repository.logout();
  }
}
