import 'package:bazar_books_app/features/auth/data/auth_repository.dart';
import 'package:bazar_books_app/features/profile/bloc/profile_event.dart';
import 'package:bazar_books_app/features/profile/bloc/profile_state.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, MyAccountState> {
  final AuthRepository authRepository;

  ProfileBloc(this.authRepository) : super(MyAccountInitialState()) {
    on<FetchUserInfoEvent>((event, emit) async {
      emit(MyAccountLoadingState());

      try {
        final user = await authRepository.getCurrentUser();

        if (user != null) {
          emit(ProfileLoadedState(user));
        } else {
          emit(ProfileErrorState('User not found'));
        }
      } catch (e) {
        emit(
          ProfileErrorState(ErrorHandler.handle(e).failure.message),
        );
      }
    });
  }
}
