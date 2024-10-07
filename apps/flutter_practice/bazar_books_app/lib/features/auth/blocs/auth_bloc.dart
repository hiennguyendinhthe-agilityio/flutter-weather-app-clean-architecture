// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_app/features/auth/blocs/auth_event.dart';
import 'package:bazar_books_app/features/auth/blocs/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(LoginInitial()) {
    on<TogglePasswordVisibilityEvent>(_handleOnTogglePasswordVisibilityEvent);
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
}
