import 'package:complaint_app/core/params/params.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

class VerifyOtp {
  final AuthRepository repository;

  VerifyOtp({required this.repository});

  Future<Either<Failure, Unit>> call(
      {required VerifyOtpParams params}) {
    return repository.verifyOtp(params: params);
  }
}
