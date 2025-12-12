import 'package:complaint_app/config/helper/injection_container.dart';
import 'package:complaint_app/core/databases/cache/cache_helper.dart';
import 'package:complaint_app/core/params/params.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failure.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl extends AuthRepository {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
      static const String AUTH_TOKEN_KEY = 'AUTH_TOKEN';
      static const String USER_EMAIL_KEY = 'USER_EMAIL';
  @override
  Future<Either<Failure, AuthEntity>> logIn(
      {required SignInParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLogIn = await remoteDataSource.logIn(params);
        if (remoteLogIn.token != null) {
        await sl<SecureStorageHelper>().saveData(
          key: AUTH_TOKEN_KEY,
          value: remoteLogIn.token,
        );
        print("Success${remoteLogIn.token}");
      
      }
        return Right(remoteLogIn);
      } on ServerException catch (e) {
        return Left(Failure(
          errMessage: e.errorModel.errorMessage,
          statusCode: e.errorModel.status,
        ));
      }
    } else {
      return Left(Failure(errMessage: 'No internet connection'));
    }
  }
  @override
  Future<Either<Failure, Unit>> register(
      {required SignUpParams params}) async {
    if (await networkInfo.isConnected) {
      try {
     await remoteDataSource.register(params);
        return Right(unit);
      } on ServerException catch (e) {
        return Left(Failure(
          errMessage: e.errorModel.errorMessage,
          statusCode: e.errorModel.status,
        ));
      }
    } else {
      return Left(Failure(errMessage: 'No internet connection'));
    }
  }
  @override
  Future<Either<Failure, Unit>> verifyOtp(
      {required VerifyOtpParams params}) async {
    if (await networkInfo.isConnected) {
      try {
     await remoteDataSource.verifyOtp(params);
        return Right(unit);
      } on ServerException catch (e) {
        return Left(Failure(
          errMessage: e.errorModel.errorMessage,
          statusCode: e.errorModel.status,
        ));
      }
    } else {
      return Left(Failure(errMessage: 'No internet connection'));
    }
  }
  @override
  Future<Either<Failure, Unit>> reSendOtp(
      {required ReSendOtpParams params}) async {
    if (await networkInfo.isConnected) {
      try {
     await remoteDataSource.reSendOtp(params);
        return Right(unit);
      } on ServerException catch (e) {
        return Left(Failure(
          errMessage: e.errorModel.errorMessage,
          statusCode: e.errorModel.status,
        ));
      }
    } else {
      return Left(Failure(errMessage: 'No internet connection'));
    }
  }
}
