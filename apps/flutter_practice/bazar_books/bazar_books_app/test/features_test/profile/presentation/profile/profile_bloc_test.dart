import 'package:bazar_books_app/features/profile/bloc/profile/profile_bloc.dart';
import 'package:bazar_books_app/features/profile/bloc/profile/profile_event.dart';
import 'package:bazar_books_app/features/profile/bloc/profile/profile_state.dart';
import 'package:bazar_books_design/core/models/auth_model/api_user.dart';
import 'package:bazar_books_design/core/utils/error_messages.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../profile_mock.dart';

void main() {
  group('ProfileBloc - _onUserInfo', () {
    late ProfileBloc bloc;
    late MockAuthRepositoryImpl mockAuthRepositoryImpl;
    late MockProfileRepositoryImpl mockProfileRepositoryImpl;

    tearDown(() {
      bloc.close();
    });

    setUp(() {
      mockAuthRepositoryImpl = MockAuthRepositoryImpl();
      mockProfileRepositoryImpl = MockProfileRepositoryImpl();

      bloc = ProfileBloc(
        authRepository: mockAuthRepositoryImpl,
        imagePicker: MockImagePicker(),
        profileRepository: mockProfileRepositoryImpl,
      );
    });

    tearDown(() {
      bloc.close();
    });

    final mockUser = ApiUser(
      userId: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [MyAccountLoadingState, ProfileLoadedState] when user is successfully fetched',
      build: () {
        when(() => mockAuthRepositoryImpl.getCurrentUser())
            .thenAnswer((_) async => mockUser);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchUserInfoEvent()),
      expect: () => [
        MyAccountLoadingState(),
        ProfileLoadedState(mockUser),
      ],
      verify: (_) {
        verify(() => mockAuthRepositoryImpl.getCurrentUser()).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [MyAccountLoadingState, ProfileErrorState] when no user is found',
      build: () {
        when(() => mockAuthRepositoryImpl.getCurrentUser())
            .thenAnswer((_) async => null);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchUserInfoEvent()),
      expect: () => [
        MyAccountLoadingState(),
        ProfileErrorState(ErrorMessages.userNotFoundFailure),
      ],
      verify: (_) {
        verify(() => mockAuthRepositoryImpl.getCurrentUser()).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [MyAccountLoadingState, ProfileErrorState] when an exception is thrown',
      build: () {
        when(() => mockAuthRepositoryImpl.getCurrentUser())
            .thenThrow(ProfileMock.mockDioError);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchUserInfoEvent()),
      expect: () => [
        MyAccountLoadingState(),
        ProfileErrorState("Not found error"),
      ],
      verify: (_) {
        verify(() => mockAuthRepositoryImpl.getCurrentUser()).called(1);
      },
    );
  });
}
