import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class LoginWithPhone extends AuthEvent {
  final String phoneNumber;

  const LoginWithPhone(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class VerifyOtp extends AuthEvent {
  final String otp;
  final String verificationId;

  const VerifyOtp({required this.otp, required this.verificationId});

  @override
  List<Object?> get props => [otp, verificationId];
}

class LoginWithEmail extends AuthEvent {
  final String email;
  final String password;

  const LoginWithEmail({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterUser extends AuthEvent {
  final String name;
  final String phone;
  final String email;
  final String password;

  const RegisterUser({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, phone, email, password];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class DemoAutoLogin extends AuthEvent {}
