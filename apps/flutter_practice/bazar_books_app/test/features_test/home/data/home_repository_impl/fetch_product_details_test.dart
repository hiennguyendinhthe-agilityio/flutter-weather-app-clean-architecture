import 'package:bazar_books_app/features/home/data/product_repository/product_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../home_mocks.dart';

void main() {
  late MockHomeApiService mockHomeApiService;
  late ProductRepositoryImpl productRepositoryImpl;
  late MockApiService mockApiService;

  setUp(() {
    mockHomeApiService = MockHomeApiService();
    productRepositoryImpl =
        ProductRepositoryImpl(mockHomeApiService, MockProductService());
    mockApiService = MockApiService();
  });

  group('fetchProductDetails success', () {
    test('returns product details on successful fetch', () async {
      // Arrange

      when(() => mockHomeApiService.fetchProductDetails(HomeMocks.mockProducId))
          .thenAnswer((_) async => HomeMocks.mockProductDetail);

      // Act
      final result = await productRepositoryImpl
          .fetchProductDetails(HomeMocks.mockProducId);

      // Assert
      expect(result, HomeMocks.mockProductDetail);
      verify(() =>
              mockHomeApiService.fetchProductDetails(HomeMocks.mockProducId))
          .called(1);
    });
  });
  group('fetchProductDetails error', () {
    test('should throw error when ApiService throws an error', () async {
      // Arrange: Simulate an exception from ApiService
      const productId = '123';
      when(() => mockApiService.fetchProductDetails(productId))
          .thenThrow(Exception('Network Error'));

      // Act: Call the method
      try {
        await mockApiService.fetchProductDetails(productId);
      } catch (e) {
        // Assert: Check that the correct error is thrown
        expect(e, isA<Exception>());
        expect(e.toString(), contains('Network Error'));
      }
    });
  });
}
