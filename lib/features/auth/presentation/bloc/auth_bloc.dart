// lib/features/auth/presentation/bloc/auth_bloc.dart

import 'package:complaint_app/features/auth/domain/entities/auth_entity.dart';
import 'package:complaint_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:complaint_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:complaint_app/features/auth/domain/usecases/otp_usecase.dart';
import 'package:complaint_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:complaint_app/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // [cite: 46]
import '../../../../core/params/params.dart'; // [cite: 42]

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LogIn loginUseCase;
  final Register registerUseCase;
  final VerifyOtp otpUseCase;
  final ResendOtp resendOtpUseCase;
  final Logout logoutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.otpUseCase,
    required this.resendOtpUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<LoginUserEvent>(_onLoginUserEvent);
    on<RegisterUserEvent>(_onRegisterUserEvent);
    on<VerifyOtpEvent>(_onVerifyOtpEvent);
    on<ResendOtpEvent>(_onResendOtpEvent);
    on<LogoutEvent>(_onLogoutEvent);
  }

  // ---------------- Login Handler ----------------

  void _onLoginUserEvent(LoginUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    // استخدام LoginParams كما هو متوقع بناءً على ملف params.dart [cite: 42]
    final result = await loginUseCase(
      params: SignInParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.errMessage)),
      (authEntity) => emit(LoginSuccessState(authEntity: authEntity)),
    );
  }

  // ---------------- Register Handler ----------------

  void _onRegisterUserEvent(
    RegisterUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    // استخدام RegisterParams
    final result = await registerUseCase(
      params: SignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.errMessage)),
      (authEntity) => emit(RegisterSuccessState()),
    );
  }

  // ---------------- OTP Verification Handler ----------------

  void _onVerifyOtpEvent(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    // استخدام OtpParams
    final result = await otpUseCase(
      params: VerifyOtpParams(email: event.email, otp: event.otpCode),
    );

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.errMessage)),
      (_) => emit(const OtpVerificationSuccessState()),
    );
  }

  // ---------------- Resend OTP Handler ----------------

  void _onResendOtpEvent(ResendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    // استخدام ResendOtpParams
    final result = await resendOtpUseCase(
      params: ReSendOtpParams(email: event.email),
    );

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.errMessage)),
      (_) => emit(const OtpResendSuccessState()),
    );
  }

  // ---------------- Logout Handler ----------------

  void _onLogoutEvent(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.errMessage)),
      (_) => emit(const LogoutSuccessState()),
    );
  }
}
