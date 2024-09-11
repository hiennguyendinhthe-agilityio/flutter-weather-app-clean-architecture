// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_app/features/auth/blocs/auth_event.dart';
import 'package:bazar_books_app/features/auth/blocs/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_handleOnLoginButtonPressed);
  }

  Future<void> _handleOnLoginButtonPressed(
      LoginButtonPressed event, Emitter<AuthState> emit) async {
    emit(LoginLoading());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (event.email == savedEmail && event.password == savedPassword) {
      emit(LoginSuccess());
    } else {
      emit(LoginFailure(error: "Email or password is incorrect"));
    }
  }
}
