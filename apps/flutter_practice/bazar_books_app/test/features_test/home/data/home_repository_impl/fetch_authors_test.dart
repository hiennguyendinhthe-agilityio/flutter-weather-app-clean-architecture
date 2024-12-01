import 'package:bazar_books_app/features/home/data/home_repository.dart';
import 'package:bazar_books_app/features/home/data/home_repository_impl.dart';
import 'package:bazar_books_design/core/network/error_handler.dart';
import 'package:bazar_books_design/core/network/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../home_mocks.dart';

void main() {
  late MockHomeApiService mockHomeApiService;
  late HomeRepository homeRepository;

  setUp(() {
    mockHomeApiService = MockHomeApiService();
    homeRepository =
        HomeRepositoryImpl(mockHomeApiService, MockProductService());
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

    test('throws error when API fetch fails', () async {
      // Arrange
      final exception = Exception('Failed to fetch authors');
      when(() => mockHomeApiService.getAuthors()).thenThrow(exception);

      // Act
      Object? result;
      try {
        await homeRepository.fetchAuthors();
      } catch (e) {
        result = e;
      }

      // Assert
      expect(
        (result as Failure).message,
        ErrorHandler.handle(exception).failure.message,
      );
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
