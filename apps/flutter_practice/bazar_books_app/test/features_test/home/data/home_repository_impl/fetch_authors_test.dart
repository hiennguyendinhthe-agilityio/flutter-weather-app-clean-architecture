import 'package:bazar_books_app/features/home/data/author_repository/author_repository.dart';
import 'package:bazar_books_app/features/home/data/author_repository/author_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../home_mocks.dart';

void main() {
  late MockHomeApiService mockHomeApiService;
  late AuthorRepository homeRepository;

  setUp(() {
    mockHomeApiService = MockHomeApiService();
    homeRepository =
        AuthorRepositoryImpl(mockHomeApiService, MockProductService());
  });

  group('fetchAuthors', () {
    test('returns list of authors on successful fetch', () async {
      // Arrange

      when(() => mockHomeApiService.getAuthors())
          .thenAnswer((_) async => HomeMocks.mockAuthorsList);

      // Act
      final result = await homeRepository.fetchAuthors();

      // Assert
      expect(result, HomeMocks.mockAuthorsList);
      verify(() => mockHomeApiService.getAuthors()).called(1);
    });

    test('returns empty list when API returns empty response', () async {
      // Arrange
      when(() => mockHomeApiService.getAuthors()).thenAnswer((_) async => []);

      // Act
      final result = await homeRepository.fetchAuthors();

      // Assert
      expect(result, isEmpty);
      verify(() => mockHomeApiService.getAuthors()).called(1);
    });
  });
}
