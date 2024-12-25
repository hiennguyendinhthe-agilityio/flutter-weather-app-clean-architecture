import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
import 'package:bazar_books_app/features/profile/bloc/profile/profile_event.dart';
import 'package:bazar_books_app/features/profile/bloc/profile/profile_state.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepositoryImpl authRepository;

  ProfileBloc(this.authRepository) : super(MyAccountInitialState()) {
    on<FetchUserInfoEvent>(_onUserInfo);
    on<LogoutRequested>(_onLogOutRequested);
  }

  Future<void> _onUserInfo(
      FetchUserInfoEvent event, Emitter<ProfileState> emit) async {
    emit(MyAccountLoadingState());

    try {
      final user = await authRepository.getCurrentUser();

      if (user != null) {
        emit(ProfileLoadedState(user));
      } else {
        emit(ProfileErrorState(
          ErrorMessages.userNotFoundFailure,
        ));
      }
    } catch (e) {
      emit(
        ProfileErrorState(ErrorHandler.handle(e).failure.message),
      );
    }
  }

  Future<void> _onLogOutRequested(
      LogoutRequested event, Emitter<ProfileState> emit) async {
    emit(AuthenticationLoading());
    await authRepository.logOut();
    emit(Unauthenticated());
  }
}
