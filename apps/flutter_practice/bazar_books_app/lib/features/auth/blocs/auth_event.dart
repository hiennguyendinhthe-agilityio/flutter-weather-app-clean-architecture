// ignore_for_file: depend_on_referenced_packages

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TogglePasswordVisibilityEvent extends AuthEvent {}

class LogInRequested extends AuthEvent {
  final String email;
  final String password;

  LogInRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class AppStarted extends AuthEvent {}

class SignUpSubmitted extends AuthEvent {
  SignUpSubmitted(
    this.name,
    this.email,
    this.password,
  );

  final String name;
  final String email;
  final String password;

  @override
  List<Object?> get props => [
        name,
        email,
        password,
      ];
}

class LogoutRequested extends AuthEvent {}
