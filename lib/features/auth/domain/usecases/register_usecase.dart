import 'package:complaint_app/core/params/params.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;

  Register({required this.repository});

  Future<Either<Failure, Unit>> call(
      {required SignUpParams params}) {
    return repository.register(params: params);
  }
}
