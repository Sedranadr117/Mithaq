import 'package:complaint_app/core/errors/failure.dart';
import 'package:complaint_app/core/params/params.dart';
import 'package:complaint_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class ResendOtp{
  final AuthRepository repository;

  ResendOtp({required this.repository});

  Future<Either<Failure, Unit>> call(
      {required ReSendOtpParams params}) {
    return repository.reSendOtp(params: params);
  }
}