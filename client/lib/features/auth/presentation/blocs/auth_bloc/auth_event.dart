part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AppStarted extends AuthEvent {}

final class SignIn extends AuthEvent {
  final String email;
  final String password;

  const SignIn({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

final class SignUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const SignUp(
      {required this.name, required this.email, required this.password});

  @override
  List<Object> get props => [name, email, password];
}

final class Logout extends AuthEvent {}
