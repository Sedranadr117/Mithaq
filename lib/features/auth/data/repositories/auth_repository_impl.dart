import 'package:complaint_app/config/helper/injection_container.dart';
import 'package:complaint_app/core/databases/cache/cache_helper.dart';
import 'package:complaint_app/core/params/params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failure.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl extends AuthRepository {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  static const String AUTH_TOKEN_KEY = 'AUTH_TOKEN';
  static const String USER_EMAIL_KEY = 'USER_EMAIL';
  static const String USER_FIRST_NAME_KEY = 'USER_FIRST_NAME';
  static const String USER_LAST_NAME_KEY = 'USER_LAST_NAME';
  static const String USER_IS_ACTIVE_KEY = 'USER_IS_ACTIVE';

  @override
  Future<Either<Failure, AuthEntity>> logIn({
    required SignInParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLogIn = await remoteDataSource.logIn(params);

        // Save token and login info to SecureStorage
        final secureStorage = sl<SecureStorageHelper>();

        // Save token
        if (remoteLogIn.token.isNotEmpty) {
          await secureStorage.saveData(
            key: AUTH_TOKEN_KEY,
            value: remoteLogIn.token,
          );
          debugPrint('✅ Token saved to SecureStorage');
        }

        // Save user info
        await secureStorage.saveData(
          key: USER_EMAIL_KEY,
          value: remoteLogIn.email,
        );
        await secureStorage.saveData(
          key: USER_FIRST_NAME_KEY,
          value: remoteLogIn.firstName,
        );
        await secureStorage.saveData(
          key: USER_LAST_NAME_KEY,
          value: remoteLogIn.lastName,
        );
        await secureStorage.saveData(
          key: USER_IS_ACTIVE_KEY,
          value: remoteLogIn.isActive.toString(),
        );

        debugPrint('✅ Login info saved to SecureStorage: ${remoteLogIn.email}');
        return Right(remoteLogIn);
      } on ServerException catch (e) {
        return Left(
          Failure(
            errMessage: e.errorModel.errorMessage,
            statusCode: e.errorModel.status,
          ),
        );
      }
    } else {
      return Left(
        Failure(
          errMessage:
              'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> register({required SignUpParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.register(params);
        return Right(unit);
      } on ServerException catch (e) {
        return Left(
          Failure(
            errMessage: e.errorModel.errorMessage,
            statusCode: e.errorModel.status,
          ),
        );
      }
    } else {
      return Left(
        Failure(
          errMessage:
              'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyOtp({
    required VerifyOtpParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.verifyOtp(params);
        return Right(unit);
      } on ServerException catch (e) {
        return Left(
          Failure(
            errMessage: e.errorModel.errorMessage,
            statusCode: e.errorModel.status,
          ),
        );
      }
    } else {
      return Left(
        Failure(
          errMessage:
              'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> reSendOtp({
    required ReSendOtpParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.reSendOtp(params);
        return Right(unit);
      } on ServerException catch (e) {
        return Left(
          Failure(
            errMessage: e.errorModel.errorMessage,
            statusCode: e.errorModel.status,
          ),
        );
      }
    } else {
      return Left(
        Failure(
          errMessage:
              'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.logout();

        // Clear all user data from SecureStorage
        final secureStorage = sl<SecureStorageHelper>();
        await secureStorage.remove(AUTH_TOKEN_KEY);
        await secureStorage.remove(USER_EMAIL_KEY);
        await secureStorage.remove(USER_FIRST_NAME_KEY);
        await secureStorage.remove(USER_LAST_NAME_KEY);
        await secureStorage.remove(USER_IS_ACTIVE_KEY);

        debugPrint('✅ Logout successful - all user data cleared');
        return Right(unit);
      } on ServerException catch (e) {
        // Even if API call fails, clear local data
        final secureStorage = sl<SecureStorageHelper>();
        await secureStorage.remove(AUTH_TOKEN_KEY);
        await secureStorage.remove(USER_EMAIL_KEY);
        await secureStorage.remove(USER_FIRST_NAME_KEY);
        await secureStorage.remove(USER_LAST_NAME_KEY);
        await secureStorage.remove(USER_IS_ACTIVE_KEY);

        debugPrint(
          '⚠️ Logout API failed but local data cleared: ${e.errorModel.errorMessage}',
        );
        return Right(
          unit,
        ); // Return success even if API fails, since we cleared local data
      }
    } else {
      // Even without internet, clear local data
      final secureStorage = sl<SecureStorageHelper>();
      await secureStorage.remove(AUTH_TOKEN_KEY);
      await secureStorage.remove(USER_EMAIL_KEY);
      await secureStorage.remove(USER_FIRST_NAME_KEY);
      await secureStorage.remove(USER_LAST_NAME_KEY);
      await secureStorage.remove(USER_IS_ACTIVE_KEY);

      debugPrint('⚠️ No internet connection - local data cleared');
      return Right(unit);
    }
  }
}
