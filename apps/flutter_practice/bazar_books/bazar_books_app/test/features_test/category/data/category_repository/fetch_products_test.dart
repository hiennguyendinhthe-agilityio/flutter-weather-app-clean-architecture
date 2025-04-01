import 'package:bazar_books_app/features/category/data/category_repository.dart';
import 'package:bazar_books_design/core/models/product_model/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../category_mock.dart';

void main() {
  late CategoryRepositoryImpl categoryRepositoryImpl;
  late MockProductService mockProductService;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    mockProductService = MockProductService();

    categoryRepositoryImpl =
        CategoryRepositoryImpl(mockApiService, mockProductService);
  });

  group('fetchProducts', () {
    test('should return data from Isar if available', () async {
      when(() => mockProductService.fetchProductsFromIsar()).thenAnswer(
          (_) async => [CategoryMock.mockProduct, CategoryMock.mockProduct]);

      final result = await categoryRepositoryImpl.fetchProducts();

      expect(result, [CategoryMock.mockProduct, CategoryMock.mockProduct]);
    });

    test('should fetch data from API and update Isar if Isar is empty',
        () async {
      final productsFromIsar = <Product>[];

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

      final result = await categoryRepositoryImpl.fetchProducts();

      expect(result, [CategoryMock.mockProduct, CategoryMock.mockProduct]);
      verify(() => mockProductService.fetchProductsFromIsar()).called(1);
      verify(() => mockProductService.fetchProductsFromApi()).called(1);
      verify(() => mockProductService.clearProductsFromIsar()).called(1);
      verify(() => mockProductService.saveProductsToIsar(
          [CategoryMock.mockProduct, CategoryMock.mockProduct])).called(1);
    });

    test('should return data from Isar if API fails and Isar has data',
        () async {
      when(() => mockProductService.fetchProductsFromIsar()).thenAnswer(
          (_) async => [CategoryMock.mockProduct, CategoryMock.mockProduct]);
      when(() => mockProductService.fetchProductsFromApi())
          .thenThrow(Exception('API Error'));

      final result = await categoryRepositoryImpl.fetchProducts();

      expect(result, [CategoryMock.mockProduct, CategoryMock.mockProduct]);
    });
  });
}
