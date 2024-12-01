part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PasswordVisibilityChanged extends AuthState {
  final bool isObscured;

  PasswordVisibilityChanged(this.isObscured);
}

class AuthenticationInitial extends AuthState {}

class AuthenticationLoading extends AuthState {}

class AuthenticationSuccess extends AuthState {
  final User user;
  AuthenticationSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class AuthenticationFailure extends AuthState {
  final String error;
  AuthenticationFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class SignUpSuccess extends AuthState {}

class SignUpFailure extends AuthState {
  final String error;

  SignUpFailure(this.error);

  @override
  List<Object?> get props => [error];
}
