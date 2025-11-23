import 'package:complaint_app/core/params/params.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class LogIn {
  final AuthRepository repository;

  LogIn({required this.repository});

  Future<Either<Failure, AuthEntity>> call(
      {required SignInParams params}) {
    return repository.logIn(params: params);
  }
}
