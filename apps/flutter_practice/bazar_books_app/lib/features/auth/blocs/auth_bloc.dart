import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/core/models/auth_model/api_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl authenticationRepository;

  AuthBloc(this.authenticationRepository) : super(AuthenticationInitial()) {
    on<IsLoggedIn>(_isLoggedIn);
    on<TogglePasswordVisibilityEvent>(_handleOnTogglePasswordVisibilityEvent);
    on<LogInRequested>(_onLogInRequested);
    on<SignUpSubmitted>(_onSignUpSubmitted);
    on<LogoutRequested>(_onLogOutRequested);
    on<PasswordValidationChanged>(_onPasswordValidationChanged);
  }

  Future<void> _isLoggedIn(IsLoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthenticationLoading());
    final isLoggedIn = await authenticationRepository.isLoggedIn();

    if (isLoggedIn) {
      final user = await authenticationRepository.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } else {
      emit(Unauthenticated());
    }
  }

  void _handleOnTogglePasswordVisibilityEvent(
      TogglePasswordVisibilityEvent event, Emitter<AuthState> emit) {
    if (state is PasswordVisibilityChanged) {
      final isPasswordObscured =
          (state as PasswordVisibilityChanged).isObscured;
      emit(PasswordVisibilityChanged(!isPasswordObscured));
    } else {
      emit(PasswordVisibilityChanged(false));
    }
  }

  Future<void> _onLogInRequested(
      LogInRequested event, Emitter<AuthState> emit) async {
    emit(AuthenticationLoading());
    try {
      final user =
          await authenticationRepository.signIn(event.email, event.password);
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(AuthenticationFailure(ErrorMessages.invalidEmailOrPassword));
      }
    } catch (e) {
      emit(AuthenticationFailure(ErrorHandler.handle(e).failure.message));
    }
  }

  Future<void> _onSignUpSubmitted(
      SignUpSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthenticationLoading());

    try {
      final isEmailDuplicate =
          await authenticationRepository.isEmailDuplicateFromAPI(event.email);
      if (isEmailDuplicate) {
        emit(SignUpFailure(
            ErrorHandler.handle(isEmailDuplicate).failure.message));
        return;
      }

      final response = await authenticationRepository.signUp(
        event.name,
        event.email,
        event.password,
      );

      if (response) {
        await authenticationRepository.saveUser(ApiUser(
          name: event.name,
          email: event.email,
          password: event.password,
          isLoggedIn: true,
        ));

        emit(Authenticated(ApiUser()));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(SignUpFailure(
        e is Failure ? e.message : ErrorMessages.emailAlreadyExists,
      ));
    }
  }

  Future<void> _onLogOutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthenticationLoading());
    await authenticationRepository.logOut();
    emit(Unauthenticated());
  }

  Future<void> _onPasswordValidationChanged(
      PasswordValidationChanged event, Emitter<AuthState> emit) async {
    final password = event.password;

    final hasMinLength = password.length >= 8;
    final hasNumber = password.contains(RegExp(r'\d'));
    final hasLetter = password.contains(RegExp(r'[a-zA-Z]'));

    emit(PasswordValidationState(
      hasMinLength: hasMinLength,
      hasNumber: hasNumber,
      hasLetter: hasLetter,
    ));
  }
}
