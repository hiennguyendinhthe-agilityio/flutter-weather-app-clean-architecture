import 'package:bazar_books_app/features/home/data/author_repository/author_repository.dart';
import 'package:bazar_books_app/features/home/data/author_repository/author_repository_impl.dart';
import 'package:bazar_books_design/core/network/failure.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../home_mocks.dart';

void main() {
  late MockHomeApiService mockHomeApiService;
  late AuthorRepository authorRepository;

  setUp(() {
    mockHomeApiService = MockHomeApiService();
    authorRepository =
        AuthorRepositoryImpl(mockHomeApiService, MockProductService());
  });

  group('fetchAuthors', () {
    test('returns list of authors on successful fetch', () async {
      when(() => mockHomeApiService.getAuthors())
          .thenAnswer((_) async => HomeMocks.mockAuthorsList);

      final result = await authorRepository.fetchAuthors();

      expect(result, HomeMocks.mockAuthorsList);
      verify(() => mockHomeApiService.getAuthors()).called(1);
    });

    test('returns empty list when API returns empty response', () async {
      when(() => mockHomeApiService.getAuthors()).thenAnswer((_) async => []);

      final result = await authorRepository.fetchAuthors();

      expect(result, isEmpty);
      verify(() => mockHomeApiService.getAuthors()).called(1);
    });
    test('Throws Exception when apiService.getAuthors error', () async {
      when(() => mockHomeApiService.getAuthors()).thenThrow(DioException(
        message: "error",
        requestOptions: RequestOptions(),
      ));

      expect(
        () async => await authorRepository.fetchAuthors(),
        throwsA(isA<Failure>()),
      );

      verify(() => mockHomeApiService.getAuthors()).called(1);
    });
  });
}
