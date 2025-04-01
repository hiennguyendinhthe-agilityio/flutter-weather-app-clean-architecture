import 'package:bazar_books_app/features/home/data/product_repository/product_repository.dart';
import 'package:bazar_books_design/core/models/product_model/product_model.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../home_mocks.dart';

void main() {
  late ProductRepositoryImpl productRepository;
  late MockApiService mockApiService;
  late MockProductService mockProductService;
  final cachedQuery = CachedQuery.instance;

  setUp(() {
    mockApiService = MockApiService();
    mockProductService = MockProductService();
    productRepository =
        ProductRepositoryImpl(mockApiService, mockProductService);
  });

  group('createFavorite', () {
    tearDownAll(cachedQuery.deleteCache);

    test('should add product to favorites the cached query on success',
        () async {
      when(() => mockApiService.addProductToFavorites(HomeMocks.testProduct))
          .thenAnswer((_) async => HomeMocks.testProduct);

      final query = CachedQuery.instance.getQuery("getFavorites")
              as Query<List<Product>?>? ??
          Query<List<Product>>(
              initialData: [],
              key: 'getFavorites',
              queryFn: () async {
                return [];
              });

      if (query.state.data == null) {
        query.update((_) => []);
      }

      final mutationResult =
          productRepository.createFavorite(HomeMocks.testProduct);

      await mutationResult.mutate(HomeMocks.testProduct);

      expect(query.state.data, isNotEmpty);
      expect(query.state.data!.first.title, 'Test Product');
    });
    test(
        'should add product to favorites and update the cached query on success',
        () async {
      when(() => mockApiService.addProductToFavorites(HomeMocks.testProduct))
          .thenAnswer((_) async => HomeMocks.testProduct);

      final query = CachedQuery.instance.getQuery("getFavorites")
          as Query<List<Product>>?;
      if (query == null) {
        CachedQuery.instance.updateQuery(
          key: "getFavorites",
          updateFn: (dynamic old) => old as List<Product>?,
        );
      }

      final mutationResult =
          productRepository.createFavorite(HomeMocks.testProduct);

      await mutationResult.mutate(HomeMocks.testProduct);

      final updatedQuery =
          CachedQuery.instance.getQuery("getFavorites") as Query<List<Product>>;
      expect(updatedQuery.state.data, isNotEmpty);
      expect(updatedQuery.state.data!.first.title, 'Test Product');
    });

    test('should update cached query with new data while keeping old data',
        () async {
      when(() => mockApiService.addProductToFavorites(HomeMocks.testProduct))
          .thenAnswer((_) async => HomeMocks.testProduct);

      final query = CachedQuery.instance.getQuery("getFavorites")
          as Query<List<Product>>?;
      if (query == null) {
        CachedQuery.instance.updateQuery(
          key: "getFavorites",
          updateFn: (dynamic old) => old as List<Product>?,
        );
      }

      final mutationResult =
          productRepository.createFavorite(HomeMocks.testProduct);

      await mutationResult.mutate(HomeMocks.testProduct);

      final updatedQuery =
          CachedQuery.instance.getQuery("getFavorites") as Query<List<Product>>;
      expect(updatedQuery.state.data, hasLength(3));
      expect(updatedQuery.state.data!.first.title, 'Test Product');
      expect(updatedQuery.state.data![1].title, 'Test Product');
    });
  });
}
