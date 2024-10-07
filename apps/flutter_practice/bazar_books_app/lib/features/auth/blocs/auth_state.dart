// ignore_for_file: depend_on_referenced_packages

import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {}

class LoginFailure extends AuthState {
  LoginFailure({required this.error});

  final String error;
  @override
  List<Object?> get props => [error];
}

class PasswordVisibilityChanged extends AuthState {
  final bool isObscured;

  PasswordVisibilityChanged(this.isObscured);
}
