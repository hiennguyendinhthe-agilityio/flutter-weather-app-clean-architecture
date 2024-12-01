import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/core/utils/error_messages.dart';
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
          await authenticationRepository.logIn(event.email, event.password);
      if (user != null) {
        emit(AuthenticationSuccess(user));
      } else {
        emit(
          AuthenticationFailure(
            ErrorMessages.invalidEmailOrPassword,
          ),
        );
      }
    } catch (e) {
      emit(
        AuthenticationFailure(ErrorHandler.handle(e).failure.message),
      );
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
        await authenticationRepository.saveUser(User(
          name: event.name,
          email: event.email,
          password: event.password,
          isLoggedIn: true,
        ));

        emit(SignUpSuccess());
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
}
