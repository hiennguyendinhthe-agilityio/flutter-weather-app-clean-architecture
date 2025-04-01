part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  ApiUser? get user => null;
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
  @override
  final ApiUser user;
  AuthenticationSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class Authenticated extends AuthState {
  @override
  final ApiUser user;

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

class PasswordValidationState extends AuthState {
  final bool hasMinLength;
  final bool hasNumber;
  final bool hasLetter;

  PasswordValidationState({
    required this.hasMinLength,
    required this.hasNumber,
    required this.hasLetter,
  });

  @override
  List<Object?> get props => [hasMinLength, hasNumber, hasLetter];
}

class BiometricAuthEnabled extends AuthState {}

class BiometricAuthFailed extends AuthState {}

class BiometricStatusChecked extends AuthState {
  final bool isBiometricEnabled;

  BiometricStatusChecked(this.isBiometricEnabled);

  @override
  List<Object?> get props => [isBiometricEnabled];
}
