// lib/features/auth/presentation/bloc/auth_event.dart

part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// ---------------- Login Events ----------------

class LoginUserEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginUserEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

// ---------------- Register Events ----------------

class RegisterUserEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const RegisterUserEvent({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object> get props => [email, password, name];
}

// ---------------- OTP Events ----------------

class VerifyOtpEvent extends AuthEvent {
  final String otpCode;
  final String email; // يمكن أن تحتاج الإيميل لتحديد المستخدم أو الجلسة

  const VerifyOtpEvent({required this.otpCode, required this.email});

  @override
  List<Object> get props => [otpCode, email];
}

class ResendOtpEvent extends AuthEvent {
  final String email;

  const ResendOtpEvent({required this.email});

  @override
  List<Object> get props => [email];
}

// ---------------- Logout Event ----------------

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}
