import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;

  const LoginRequested(this.email);

  @override
  List<Object?> get props => [email];
}

class LogoutRequested extends AuthEvent {}

class VerifyMagicLinkRequested extends AuthEvent {
  final String token;

  const VerifyMagicLinkRequested(this.token);

  @override
  List<Object?> get props => [token];
}

class LoginWithTokenRequested extends AuthEvent {
  final String email;
  final String token;

  const LoginWithTokenRequested({required this.email, required this.token});

  @override
  List<Object?> get props => [email, token];
}
