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

      final result = await productRepository.fetchProducts();

      expect(result, [HomeMocks.mockProduct, HomeMocks.mockProduct]);
    });

    test('should fetch data from API and update Isar if Isar is empty',
        () async {
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

      final result = await productRepository.fetchProducts();

      expect(result, [HomeMocks.mockProduct, HomeMocks.mockProduct]);
      verify(() => mockProductService.fetchProductsFromIsar()).called(1);
      verify(() => mockProductService.fetchProductsFromApi()).called(1);
      verify(() => mockProductService.clearProductsFromIsar()).called(1);
      verify(() => mockProductService.saveProductsToIsar(
          [HomeMocks.mockProduct, HomeMocks.mockProduct])).called(1);
    });

    test('should return data from Isar if API fails and Isar has data',
        () async {
      when(() => mockProductService.fetchProductsFromIsar()).thenAnswer(
          (_) async => [HomeMocks.mockProduct, HomeMocks.mockProduct]);
      when(() => mockProductService.fetchProductsFromApi())
          .thenThrow(Exception('API Error'));

      final result = await productRepository.fetchProducts();

      expect(result, [HomeMocks.mockProduct, HomeMocks.mockProduct]);
    });
  });
}
