import 'package:bazar_books_app/core/l10n_generated/l10n.dart';
import 'package:bazar_books_app/features/auth/blocs/auth_event.dart';
import 'package:bazar_books_app/features/auth/blocs/auth_state.dart';
import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
import 'package:bazar_books_design/core/network/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl authenticationRepository;

  AuthBloc(this.authenticationRepository) : super(AuthenticationInitial()) {
    on<AppStarted>(_onAppStarted);
    on<TogglePasswordVisibilityEvent>(_handleOnTogglePasswordVisibilityEvent);
    on<LogInRequested>(_onLogInRequested);
    on<SignUpSubmitted>(_onSignUpSubmitted);
    on<LogoutRequested>(_onLogOutRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
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
        emit(AuthenticationFailure(
          S.current.authenticationFailure,
        ));
      }
    } catch (e) {
      emit(AuthenticationFailure(ErrorHandler.handle(e).failure.message));
    }
  }

  Future<void> _onSignUpSubmitted(
      SignUpSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthenticationLoading());

    try {
      final response = await authenticationRepository.signUp(
        event.name,
        event.email,
        event.password,
      );

      if (response) {
        emit(SignUpSuccess());
      } else {
        emit(SignUpFailure(
          S.current.authenticationFailure,
        ));
      }
    } catch (e) {
      emit(AuthenticationFailure(ErrorHandler.handle(e).failure.message));
    }
  }

  Future<void> _onLogOutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthenticationLoading());
    await authenticationRepository.logOut();
    emit(Unauthenticated());
  }
}
