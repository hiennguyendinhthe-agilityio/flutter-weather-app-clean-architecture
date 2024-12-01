import 'dart:math';

import 'package:bazar_books_app/features/home/data/home_repository_impl.dart';
import 'package:bazar_books_design/core/network/error_handler.dart';
import 'package:bazar_books_design/core/network/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../home_mocks.dart';

void main() {
  late MockHomeApiService mockHomeApiService;
  late HomeRepositoryImpl homeRepository;

  setUp(() {
    mockHomeApiService = MockHomeApiService();
    homeRepository =
        HomeRepositoryImpl(mockHomeApiService, MockProductService());
  });

  group('fetchAuthorProfile', () {
    test('returns Author Profile on successful fetch', () async {
      // Arrange

      when(() => mockHomeApiService.fetchAuthorProfile(HomeMocks.mockAuthorId))
          .thenAnswer((_) async => HomeMocks.mockAuthor);

      // Act
      final result =
          await homeRepository.fetchAuthorProfile(HomeMocks.mockAuthorId);

      // Assert
      expect(result, HomeMocks.mockAuthor);
      verify(() =>
              mockHomeApiService.fetchAuthorProfile(HomeMocks.mockAuthorId))
          .called(1);
    });

    test('throws error when API fetch fails', () async {
      // Arrange
      when(() => mockHomeApiService.fetchAuthorProfile(HomeMocks.mockAuthorId))
          .thenThrow(
        ErrorHandler.handle(e).failure,
      );

      // Act
      Object? result;
      try {
        await homeRepository.fetchAuthorProfile(HomeMocks.mockAuthorId);
      } catch (e) {
        result = e;
      }

      // Assert
      expect(
        (result as Failure).message,
        ErrorHandler.handle(e).failure.message,
      );
      verify(() =>
              mockHomeApiService.fetchAuthorProfile(HomeMocks.mockAuthorId))
          .called(1);
    });
  });
}
