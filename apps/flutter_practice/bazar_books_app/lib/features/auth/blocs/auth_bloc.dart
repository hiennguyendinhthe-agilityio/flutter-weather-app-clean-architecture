import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/core/models/auth_model/api_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl authenticationRepository;
  final LocalAuthentication auth;

  late SharedPreferences _prefs;
  AuthBloc(this.authenticationRepository, this.auth)
      : super(AuthenticationInitial()) {
    _initPreferences();
    on<IsLoggedIn>(_isLoggedIn);
    on<TogglePasswordVisibilityEvent>(_handleOnTogglePasswordVisibilityEvent);
    on<LogInRequested>(_onLogInRequested);
    on<SignUpSubmitted>(_onSignUpSubmitted);
    on<LogoutRequested>(_onLogOutRequested);
    on<PasswordValidationChanged>(_onPasswordValidationChanged);
    on<EnableBiometricAuth>(_onEnableBiometricAuth);
    on<BiometricAuthRequested>(_onBiometricAuthRequested);
    on<CheckBiometricStatus>(_onCheckBiometricStatus);
  }

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _onCheckBiometricStatus(
      CheckBiometricStatus event, Emitter<AuthState> emit) async {
    final isBiometricEnabled = _prefs.getBool('biometricEnabled') ?? false;

    emit(BiometricStatusChecked(isBiometricEnabled));
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
        await _prefs.setString('saved_email', event.email);
        await _prefs.setString('saved_password', event.password);
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

  Future<void> _onEnableBiometricAuth(
      EnableBiometricAuth event, Emitter<AuthState> emit) async {
    await _prefs.setBool('biometricEnabled', true);
    emit(BiometricAuthEnabled());
    add(CheckBiometricStatus());
  }

  Future<void> _onBiometricAuthRequested(
      BiometricAuthRequested event, Emitter<AuthState> emit) async {
    final bool isBiometricEnabled = _prefs.getBool('biometricEnabled') ?? false;

    if (!isBiometricEnabled) {
      emit(BiometricAuthFailed());
      return;
    }

    try {
      final bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Biometric authentication for login',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );

      if (!isAuthenticated) {
        emit(BiometricAuthFailed());
        return;
      }

      final String? savedEmail = _prefs.getString('saved_email');
      final String? savedPassword = _prefs.getString('saved_password');

      if (savedEmail == null || savedPassword == null) {
        emit(AuthenticationFailure(
            "No saved email or password found. Please log in again."));
        return;
      }

      final user =
          await authenticationRepository.signIn(savedEmail, savedPassword);

      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(AuthenticationFailure('Invalid email or password'));
      }
    } catch (e) {
      emit(AuthenticationFailure(
          "Biometric authentication failed: ${e.toString()}"));
    }
  }
}
