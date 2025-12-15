part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// ---------------- Initial/Loading State ----------------

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

// ---------------- Success States ----------------

class LoginSuccessState extends AuthState {
  final AuthEntity authEntity;

  const LoginSuccessState({required this.authEntity});

  @override
  List<Object> get props => [authEntity];
}

class RegisterSuccessState extends AuthState {
  const RegisterSuccessState();

  @override
  List<Object> get props => [];
}

class OtpVerificationSuccessState extends AuthState {
  // يمكن أن يحتوي على رسالة أو بيانات الجلسة
  final String message;

  const OtpVerificationSuccessState({
    this.message = 'OTP Verified Successfully',
  });

  @override
  List<Object> get props => [message];
}

class OtpResendSuccessState extends AuthState {
  final String message;

  const OtpResendSuccessState({this.message = 'OTP Resent Successfully'});

  @override
  List<Object> get props => [message];
}

class LogoutSuccessState extends AuthState {
  const LogoutSuccessState();
}

// ---------------- Error State ----------------

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
