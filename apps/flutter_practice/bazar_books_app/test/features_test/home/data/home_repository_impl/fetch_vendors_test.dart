import 'dart:math';

import 'package:bazar_books_app/features/home/data/home_repository_impl.dart';
import 'package:bazar_books_design/core/network/error_handler.dart';
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

  group('fetchVendors', () {
    test('returns list of vendors on successful fetch', () async {
      // Arrange

      when(() => mockHomeApiService.getVendors(page: 1, limit: 10))
          .thenAnswer((_) async => HomeMocks.mockVendorList);

      // Act
      final result = await homeRepository.fetchVendors(page: 1, limit: 10);

      // Assert
      expect(result, HomeMocks.mockVendorList);
      verify(() => mockHomeApiService.getVendors(page: 1, limit: 10)).called(1);
    });

    test('throws error when API fetch fails', () async {
      // Arrange
      final exception = Exception('Failed to fetch vendors');
      when(() => mockHomeApiService.getVendors(page: 1, limit: 10))
          .thenThrow(exception);

      // Act
      Object? result;
      try {
        await homeRepository.fetchVendors(page: 1, limit: 10);
      } catch (e) {
        result = ErrorHandler.handle(e).failure.message;
      }

      // Assert
      expect(result, ErrorHandler.handle(e).failure.message);
      verify(() => mockHomeApiService.getVendors(page: 1, limit: 10)).called(1);
    });

    test('supports pagination by passing correct page and limit', () async {
      // Arrange

      when(() => mockHomeApiService.getVendors(page: 2, limit: 5))
          .thenAnswer((_) async => HomeMocks.mockVendorList);

      // Act
      final result = await homeRepository.fetchVendors(page: 2, limit: 5);

      // Assert
      expect(result, HomeMocks.mockVendorList);
      verify(() => mockHomeApiService.getVendors(page: 2, limit: 5)).called(1);
    });

    test('returns empty list when API returns empty response', () async {
      // Arrange
      when(() => mockHomeApiService.getVendors(page: 1, limit: 10))
          .thenAnswer((_) async => []);

      // Act
      final result = await homeRepository.fetchVendors(page: 1, limit: 10);

      // Assert
      expect(result, isEmpty);
      verify(() => mockHomeApiService.getVendors(page: 1, limit: 10)).called(1);
    });
  });
}
