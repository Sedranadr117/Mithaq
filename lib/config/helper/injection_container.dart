import 'package:complaint_app/core/connection/network_info.dart';
import 'package:complaint_app/core/databases/api/api_consumer.dart';
import 'package:complaint_app/core/databases/api/dio_consumer.dart';
import 'package:complaint_app/core/databases/cache/cache_helper.dart';
import 'package:complaint_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:complaint_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:complaint_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:complaint_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:complaint_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:complaint_app/features/auth/domain/usecases/otp_usecase.dart';
import 'package:complaint_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:complaint_app/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:complaint_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:complaint_app/features/complaints/data/datasources/complaints_remote_data_source.dart';
import 'package:complaint_app/features/complaints/data/repositories/complaints_repository_impl.dart';
import 'package:complaint_app/features/complaints/domain/repositories/complaints_repository.dart';
import 'package:complaint_app/features/complaints/domain/usecases/add_complaints.dart';
import 'package:complaint_app/features/complaints/domain/usecases/get_all_complaint.dart';
import 'package:complaint_app/features/complaints/domain/usecases/get_info_requests_for_complaint.dart';
import 'package:complaint_app/features/complaints/domain/usecases/respond_to_info_request.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/respond_info_request/respond_info_request_bloc.dart';
import 'package:complaint_app/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:complaint_app/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:complaint_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:complaint_app/features/notification/domain/usecases/delete_fcm_token.dart';
import 'package:complaint_app/features/notification/domain/usecases/get_notification.dart';
import 'package:complaint_app/features/notification/domain/usecases/mark_notification_read.dart';
import 'package:complaint_app/features/notification/domain/usecases/post_fcm_token.dart';
import 'package:complaint_app/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  ///---Storage
  sl.registerLazySingleton<SecureStorageHelper>(
    () => SecureStorageHelper.instance,
  );

  /// ——————— CORE
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  /// ——————— EXTERNAL
  sl.registerLazySingleton(() => Dio());

  sl.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(
      dio: sl<Dio>(),
      secureStorageHelper: sl<SecureStorageHelper>(),
    ),
  );

  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      otpUseCase: sl(),
      resendOtpUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  // ==================== 2. Domain Layer (USE CASES) ====================

  // يتم تسجيل الـ UseCase كـ LazySingleton لأنه لا يحتوي على حالة (State) ويستخدم في أماكن متعددة
  sl.registerLazySingleton(() => LogIn(repository: sl()));
  sl.registerLazySingleton(() => Register(repository: sl()));
  sl.registerLazySingleton(() => VerifyOtp(repository: sl()));
  sl.registerLazySingleton(() => ResendOtp(repository: sl()));
  sl.registerLazySingleton(() => Logout(repository: sl()));

  // ==================== 3. Data Layer (REPOSITORIES & DATA SOURCES) ====================

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data Sources (Remote)
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(api: sl()),
  );

  // Data sources
  sl.registerLazySingleton(() => ComplaintsRemoteDataSource(api: sl()));

  // Repository
  sl.registerLazySingleton<ComplaintRepository>(
    () => ComplaintRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllComplaint(repository: sl()));
  sl.registerLazySingleton(() => AddComplaint(repository: sl()));
  sl.registerLazySingleton(() => RespondToInfoRequest(repository: sl()));
  sl.registerLazySingleton(() => GetInfoRequestsForComplaint(repository: sl()));

  // Blocs
  sl.registerFactory(
    () => RespondInfoRequestBloc(
      respondToInfoRequestUseCase: sl(),
      getInfoRequestsForComplaintUseCase: sl(),
    ),
  );

  // ==================== NOTIFICATION ====================

  // Data sources
  sl.registerLazySingleton(() => NotificationRemoteDataSource(api: sl()));

  // Repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetNotification(repository: sl()));
  sl.registerLazySingleton(() => PostFcmToken(repository: sl()));
  sl.registerLazySingleton(() => DeleteFcmToken(repository: sl()));
  sl.registerLazySingleton(() => MarkNotificationRead(repository: sl()));

  // Bloc
  sl.registerFactory(
    () => NotificationBloc(
      getNotification: sl(),
      postFcmToken: sl(),
      deleteFcmToken: sl(),
      markNotificationRead: sl(),
    ),
  );
}
