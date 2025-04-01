import 'package:bazar_books_app/features/category/data/category_repository.dart';
import 'package:bazar_books_design/core/models/product_model/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../category_mock.dart';

void main() {
  late MockProductRepository mockProductRepository;
  late CategoryRepositoryImpl categoryRepositoryImpl;
  late MockProductService mockProductService;
  late MockApiService mockApiService;

  setUp(() {
    mockProductRepository = MockProductRepository();
    mockApiService = MockApiService();
    mockProductService = MockProductService();
    categoryRepositoryImpl =
        CategoryRepositoryImpl(mockApiService, mockProductService);
  });

  group('categoryRepositoryImpl.fetchFilterCategory', () {
    test('should fetch all products if category is "All"', () async {
      final allProducts = [CategoryMock.mockProduct, CategoryMock.mockProduct];
      final productsFromIsar = <Product>[];
      when(() => mockProductRepository.fetchProducts())
          .thenAnswer((_) async => allProducts);
      when(() => mockProductService.fetchProductsFromIsar())
          .thenAnswer((_) async => productsFromIsar);
      when(() => mockProductService.fetchProductsFromApi()).thenAnswer(
          (_) async => [CategoryMock.mockProduct, CategoryMock.mockProduct]);
      when(() => mockProductService.clearProductsFromIsar())
          .thenAnswer((_) async {
        return;
      });
      when(() => mockProductService.saveProductsToIsar(
              [CategoryMock.mockProduct, CategoryMock.mockProduct]))
          .thenAnswer((_) async {
        return;
      });

      final result = await categoryRepositoryImpl.fetchFilterCategory('All');

      expect(result, allProducts);
    });

    test('should return filtered data from Isar if category matches', () async {
      const category = 'Electronics';

      when(() => mockProductService.fetchProductsFromIsar())
          .thenAnswer((_) async => CategoryMock.mockproductsFromIsar);

      final result = await categoryRepositoryImpl.fetchFilterCategory(category);

      expect(result, CategoryMock.mockproductsFromIsar);
    });
  });
}
