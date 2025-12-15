import 'package:complaint_app/core/params/params.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> logIn({required SignInParams params});
  Future<Either<Failure, Unit>> register({required SignUpParams params});
  Future<Either<Failure, Unit>> verifyOtp({required VerifyOtpParams params});
  Future<Either<Failure, Unit>> reSendOtp({required ReSendOtpParams params});
  Future<Either<Failure, Unit>> logout();
}
