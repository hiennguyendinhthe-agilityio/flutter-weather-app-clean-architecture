// ignore_for_file: unused_result

import 'package:bazar_books_app/features/home/bloc/author_bloc/author_bloc.dart';
import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../home_mocks.dart';

void main() {
  late AuthorBloc authorBloc;
  late MockHomeRepository mockAuthorRepository;

  setUp(() {
    mockAuthorRepository = MockHomeRepository();
    authorBloc = AuthorBloc(repository: mockAuthorRepository);
  });

  tearDown(() {
    authorBloc.close();
  });

  group('Test FetchAuthor', () {
    blocTest<AuthorBloc, FetchDataState<Author>>(
      '''
      Scenario: Fetch authors successfully
        Given AuthorBloc has initial state as FetchDataState.initial()
        When GetAuthorsEvent is added
        Then AuthorBloc should emit [FetchDataState.loading(), FetchDataState.loaded(authors)]
      ''',
      build: () {
        when(() => mockAuthorRepository.fetchAuthors())
            .thenAnswer((_) async => HomeMocks.mockFetchAuthors);
        return authorBloc;
      },
      act: (bloc) => bloc.add(GetAuthorsEvent()),
      expect: () => [
        const FetchDataState<Author>.loading(),
        isA<FetchDataState<Author>>()
          ..having(
            (entity) => entity,
            'View state FetchDataState.loaded(authors)',
            equals([HomeMocks.mockFetchAuthors]),
          ),
      ],
    );

    blocTest<AuthorBloc, FetchDataState<Author>>(
      '''
      Scenario: Fetch authors with empty result
        Given AuthorBloc has initial state as FetchDataState.initial()
        When GetAuthorsEvent is added
        Then AuthorBloc should emit [FetchDataState.loading(), FetchDataState.initial()]
      ''',
      build: () {
        when(() => mockAuthorRepository.fetchAuthors())
            .thenAnswer((_) async => []);
        return authorBloc;
      },
      act: (bloc) => bloc.add(GetAuthorsEvent()),
      expect: () => [
        const FetchDataState<Author>.loading(),
        const FetchDataState<Author>.initial(),
      ],
    );

    blocTest<AuthorBloc, FetchDataState<Author>>(
      '''
      Scenario: Error fetching authors
        Given AuthorBloc has initial state as FetchDataState.initial()
        When GetAuthorsEvent is added
        Then AuthorBloc should emit [FetchDataState.loading(), FetchDataState.error("Error message")]
      ''',
      build: () {
        when(() => mockAuthorRepository.fetchAuthors()).thenThrow(
          DioException(
            message: "Failed to load authors",
            requestOptions: RequestOptions(path: ''),
          ),
        );
        return authorBloc;
      },
      act: (bloc) => bloc.add(GetAuthorsEvent()),
      expect: () => [
        const FetchDataState<Author>.loading(),
        isA<FetchDataState<Author>>()
          ..having(
            (entity) => entity,
            'Failed to load authors',
            equals(
                [const FetchDataState<Author>.error('Failed to load authors')]),
          ),
        // const FetchDataState<Author>.error('Failed to load authors'),
      ],
    );

    blocTest<AuthorBloc, FetchDataState<Author>>(
      '''
      Scenario: Fetch author profile successfully
        Given AuthorBloc has initial state as FetchDataState.initial()
        When FetchAuthorProfileEvent with id is added
        Then AuthorBloc should emit [FetchDataState.loading(), FetchDataState.loaded(author)]
      ''',
      build: () {
        when(() => mockAuthorRepository.fetchAuthorProfile('1'))
            .thenAnswer((_) async => HomeMocks.mockFetchAuthorProfile);
        return authorBloc;
      },
      act: (bloc) => bloc.add(FetchAuthorProfileEvent('1')),
      expect: () => [
        const FetchDataState<Author>.loading(),
        isA<FetchDataState<Author>>()
          ..having(
            (entity) => entity,
            'View state FetchDataState.loaded(authors)',
            equals([HomeMocks.mockFetchAuthors]),
          ),
      ],
    );

    blocTest<AuthorBloc, FetchDataState<Author>>(
      '''
      Scenario: Error fetching author profile
        Given AuthorBloc has initial state as FetchDataState.initial()
        When FetchAuthorProfileEvent with id is added
        Then AuthorBloc should emit [FetchDataState.loading(), FetchDataState.error("Error message")]
      ''',
      build: () {
        when(() => mockAuthorRepository.fetchAuthorProfile('1')).thenThrow(
          DioException(
            message: "Failed to load author profile",
            requestOptions: RequestOptions(path: ''),
          ),
        );
        return authorBloc;
      },
      act: (bloc) => bloc.add(FetchAuthorProfileEvent('1')),
      expect: () => [
        const FetchDataState<Author>.loading(),
        isA<FetchDataState<Author>>()
          ..having(
            (entity) => entity,
            'Failed to load author profile',
            equals([
              const FetchDataState<Author>.error(
                  'Failed to load author profile'),
            ]),
          ),
      ],
    );
  });
}
