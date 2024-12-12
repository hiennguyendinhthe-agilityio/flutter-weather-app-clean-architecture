import 'package:bazar_books_app/features/home/data/product_repository/product_repository.dart';
import 'package:bazar_books_design/core/models/product_model/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../home_mocks.dart';

void main() {
  late ProductRepository productRepository;
  late MockApiService mockApiService;
  late MockProductService mockProductService;

  setUp(() {
    mockApiService = MockApiService();
    mockProductService = MockProductService();

    productRepository =
        ProductRepositoryImpl(mockApiService, mockProductService);
  });

  group('fetchProducts', () {
    test('should return data from Isar if available', () async {
      when(() => mockProductService.fetchProductsFromIsar()).thenAnswer(
          (_) async => [HomeMocks.mockProduct, HomeMocks.mockProduct]);

      // Act: Call the method
      final result = await productRepository.fetchProducts();

      // Assert: Ensure it returns the data from Isar
      expect(result, [HomeMocks.mockProduct, HomeMocks.mockProduct]);
    });

    test('should fetch data from API and update Isar if Isar is empty',
        () async {
      // Arrange: Simulate no data in Isar and a successful API call
      final productsFromIsar = <Product>[];

      when(() => mockProductService.fetchProductsFromIsar())
          .thenAnswer((_) async => productsFromIsar);
      when(() => mockProductService.fetchProductsFromApi()).thenAnswer(
          (_) async => [HomeMocks.mockProduct, HomeMocks.mockProduct]);
      when(() => mockProductService.clearProductsFromIsar())
          .thenAnswer((_) async {
        return;
      });
      when(() => mockProductService.saveProductsToIsar(
              [HomeMocks.mockProduct, HomeMocks.mockProduct]))
          .thenAnswer((_) async {
        return;
      });

      // Act: Call the method
      final result = await productRepository.fetchProducts();

      // Assert: Ensure it fetches data from API and updates Isar
      expect(result, [HomeMocks.mockProduct, HomeMocks.mockProduct]);
      verify(() => mockProductService.fetchProductsFromIsar()).called(1);
      verify(() => mockProductService.fetchProductsFromApi()).called(1);
      verify(() => mockProductService.clearProductsFromIsar()).called(1);
      verify(() => mockProductService.saveProductsToIsar(
          [HomeMocks.mockProduct, HomeMocks.mockProduct])).called(1);
    });

    test('should return data from Isar if API fails and Isar has data',
        () async {
      // Arrange: Simulate no data in Isar and an API failure

      when(() => mockProductService.fetchProductsFromIsar()).thenAnswer(
          (_) async => [HomeMocks.mockProduct, HomeMocks.mockProduct]);
      when(() => mockProductService.fetchProductsFromApi())
          .thenThrow(Exception('API Error'));

      // Act: Call the method
      final result = await productRepository.fetchProducts();

      // Assert: Ensure it returns data from Isar since API failed
      expect(result, [HomeMocks.mockProduct, HomeMocks.mockProduct]);
    });
  });
}
