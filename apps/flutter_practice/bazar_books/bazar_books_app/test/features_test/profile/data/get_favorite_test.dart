import 'package:bazar_books_app/features/profile/data/favorite_repository.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../profile_mock.dart';

void main() {
  late MockApiService mockApiService;
  late MockProductService mockProductService;
  late FavoriteRepositoryImpl repository;

  setUp(() {
    mockApiService = MockApiService();
    mockProductService = MockProductService();
    repository = FavoriteRepositoryImpl(mockApiService, mockProductService);

    CachedQuery.instance.deleteCache();
  });

  group('getFavorites Tests', () {
    test('getFavorites returns data correctly', () async {
      when(() => mockApiService.getFavorites(ProfileMock.userId))
          .thenAnswer((_) async => ProfileMock.mockProductList);

      final query = repository.getFavorites(ProfileMock.userId);
      final result = await query.result;

      expect(result.data, ProfileMock.mockProductList);
      verify(() => mockApiService.getFavorites(ProfileMock.userId)).called(1);
    });

    test('Query respects cacheDuration', () async {
      when(() => mockApiService.getFavorites(ProfileMock.userId))
          .thenAnswer((_) async => ProfileMock.mockProductList);

      final query = repository.getFavorites(ProfileMock.userId);

      final result1 = await query.result;
      await Future.delayed(const Duration(seconds: 3));
      final result2 = await query.result;

      expect(result1.data, ProfileMock.mockProductList);
      expect(result2.data, ProfileMock.mockProductList);
      verify(() => mockApiService.getFavorites(ProfileMock.userId)).called(1);
    });

    test('Query refetches after refetchDuration expires', () async {
      when(() => mockApiService.getFavorites(ProfileMock.userId))
          .thenAnswer((_) async => ProfileMock.mockProductList);

      final query = repository.getFavorites(ProfileMock.userId);

      final result1 = await query.result;
      await Future.delayed(const Duration(seconds: 6));
      final result2 = await query.result;

      expect(result1.data, ProfileMock.mockProductList);
      expect(result2.data, ProfileMock.mockProductList);
      verify(() => mockApiService.getFavorites(ProfileMock.userId)).called(1);
    });

    test('getFavorites handles API errors gracefully', () async {
      when(() => mockApiService.getFavorites(ProfileMock.userId))
          .thenThrow(Exception('API error'));

      final query = repository.getFavorites(ProfileMock.userId);
      final result = await query.result;

      expect(result.status, QueryStatus.error);
      expect(result.error, isA<Exception>());
      verify(() => mockApiService.getFavorites(ProfileMock.userId)).called(1);
    });

    test('Manual update works correctly', () async {
      when(() => mockApiService.getFavorites(ProfileMock.userId))
          .thenAnswer((_) async => ProfileMock.mockProductList);

      final query = repository.getFavorites(ProfileMock.userId);

      await query.result;
      query.update((oldData) => ProfileMock.mockProductList);

      expect(query.state.data, ProfileMock.mockProductList);
      verify(() => mockApiService.getFavorites(ProfileMock.userId)).called(1);
    });

    test('Deleting cache removes the query', () async {
      when(() => mockApiService.getFavorites(ProfileMock.userId))
          .thenAnswer((_) async => ProfileMock.mockProductList);

      final query = repository.getFavorites(ProfileMock.userId);
      await query.result;

      query.deleteQuery();

      final cachedQuery = CachedQuery.instance.getQuery('getFavorites');
      expect(cachedQuery, isNull);
    });

    test('Invalidate query marks it as stale', () async {
      when(() => mockApiService.getFavorites(ProfileMock.userId))
          .thenAnswer((_) async => ProfileMock.mockProductList);

      final query = repository.getFavorites(ProfileMock.userId);
      await query.result;

      query.invalidateQuery();

      expect(query.stale, true);
    });

    test('getFavorites handles empty list from API', () async {
      when(() => mockApiService.getFavorites(ProfileMock.userId))
          .thenAnswer((_) async => []);

      final query = repository.getFavorites(ProfileMock.userId);
      final result = await query.result;

      expect(result.data, isEmpty);
      expect(result.status, QueryStatus.success);
      verify(() => mockApiService.getFavorites(ProfileMock.userId)).called(1);
    });

    test('getFavorites handles unexpected exceptions gracefully', () async {
      when(() => mockApiService.getFavorites(ProfileMock.userId))
          .thenThrow(ArgumentError('Invalid argument'));

      final query = repository.getFavorites(ProfileMock.userId);
      final result = await query.result;

      expect(result.status, QueryStatus.error);
      expect(result.error, isA<ArgumentError>());
      verify(() => mockApiService.getFavorites(ProfileMock.userId)).called(1);
    });

    test('getFavorites does not refetch if cache is valid', () async {
      when(() => mockApiService.getFavorites(ProfileMock.userId))
          .thenAnswer((_) async => ProfileMock.mockProductList);

      final query = repository.getFavorites(ProfileMock.userId);

      await query.result;
      final result2 = await query.result;

      expect(result2.data, ProfileMock.mockProductList);
      verify(() => mockApiService.getFavorites(ProfileMock.userId)).called(1);
    });

    test('getFavorites deduplicates concurrent refetch requests', () async {
      int fetchCount = 0;
      when(() => mockApiService.getFavorites(ProfileMock.userId))
          .thenAnswer((_) async {
        fetchCount++;
        return ProfileMock.mockProductList;
      });

      final query = repository.getFavorites(ProfileMock.userId);

      final results = await Future.wait([
        query.refetch(),
        query.refetch(),
        query.refetch(),
      ]);

      expect(results.map((e) => e.data),
          everyElement(ProfileMock.mockProductList));
      expect(fetchCount, 1);
    });
  });
}
