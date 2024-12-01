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

  group('fetchProductDetails', () {
    test('returns product details on successful fetch', () async {
      // Arrange

      when(() => mockHomeApiService.fetchProductDetails(HomeMocks.mockProducId))
          .thenAnswer((_) async => HomeMocks.mockProductDetail);

      // Act
      final result =
          await homeRepository.fetchProductDetails(HomeMocks.mockProducId);

      // Assert
      expect(result, HomeMocks.mockProductDetail);
      verify(() =>
              mockHomeApiService.fetchProductDetails(HomeMocks.mockProducId))
          .called(1);
    });

    test('throws error when API fetch fails', () async {
      // Arrange
      when(() => mockHomeApiService.fetchProductDetails(HomeMocks.mockProducId))
          .thenThrow(
        ErrorHandler.handle(e).failure,
      );

      // Act
      Object? result;
      try {
        await homeRepository.fetchProductDetails(HomeMocks.mockProducId);
      } catch (e) {
        result = e;
      }

      // Assert
      expect(
        (result as Failure).message,
        ErrorHandler.handle(e).failure.message,
      );
      verify(() =>
              mockHomeApiService.fetchProductDetails(HomeMocks.mockProducId))
          .called(1);
    });
  });
}
