import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_app/features/home/data/home_repository_impl.dart';
import 'package:bazar_books_design/core/models/product_model/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../home_mocks.dart';

void main() {
  late HomeRepositoryImpl homeRepository;
  late MockHomeApiService mockApiService;
  late MockProductService mockProductService;

  setUp(() {
    mockApiService = MockHomeApiService();
    mockProductService = MockProductService();

    homeRepository = HomeRepositoryImpl(mockApiService, mockProductService);
  });

  group('fetchProducts', () {
    test('should return products from Isar if available', () async {
      when(() => mockProductService.fetchProductsFromIsar())
          .thenAnswer((_) async => [HomeMocks.mockProduct]);

      // Act
      final result = await homeRepository.fetchProducts();

      // Assert
      expect(result, [HomeMocks.mockProduct]);
      verifyNever(() => mockProductService.fetchProductsFromApi());
    });

    test(
        'should return products from Isar if API fails and data is available in Isar',
        () async {
      // Arrange

      when(() => mockProductService.fetchProductsFromIsar())
          .thenAnswer((_) async => [HomeMocks.mockProduct]);
      when(() => mockProductService.fetchProductsFromApi())
          .thenThrow(Exception('API failed'));

      // Act
      final result = await homeRepository.fetchProducts();

      // Assert
      expect(result, [HomeMocks.mockProduct]);
      verifyNever(() => mockProductService.clearProductsFromIsar());
      verifyNever(
          () => mockProductService.saveProductsToIsar([HomeMocks.mockProduct]));
    });

    test('should throw an error if API fails and no data in Isar', () async {
      // Arrange
      when(() => mockProductService.fetchProductsFromIsar())
          .thenAnswer((_) async => []);
      when(() => mockProductService.fetchProductsFromApi())
          .thenThrow(Exception('API failed'));

      // Act & Assert
      expect(
        () async => await homeRepository.fetchProducts(),
        throwsA(isA<FetchDataState<List<Product>>>()),
      );
    });
  });
}
