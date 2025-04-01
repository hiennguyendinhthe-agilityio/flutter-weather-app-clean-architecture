import 'package:bazar_books_app/features/home/data/vendor_repository/vendor_repository.dart';
import 'package:bazar_books_design/core/models/vendor_model/vendor_model.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../presentation/vendor_bloc/vendor_mocks.dart';

void main() {
  late MockVendorApiService mockApiService;
  late VendorRepositoryImpl repository;

  setUp(() {
    mockApiService = MockVendorApiService();
    repository = VendorRepositoryImpl(mockApiService);
    CachedQuery.instance.deleteCache(key: VendorMocks.mockKeyVendors);
  });

  tearDown(() {
    CachedQuery.instance.deleteCache(key: VendorMocks.mockKeyVendors);
  });

  group("creating a query", () {
    test('Query is created and returns data', () async {
      when(() => mockApiService.getMoreVendors(
              page: any(named: 'page'), limit: any(named: 'limit')))
          .thenAnswer((_) async => VendorMocks.mockVendorsResponse());

      final query = repository.fetchInfiniteVendors();
      final result = await query.result;

      expect(result.data?.first, VendorMocks.vendors);
      verify(() => mockApiService.getMoreVendors(
          page: any(named: 'page'), limit: any(named: 'limit'))).called(1);
    });
  });

  group("Infinite query as a future", () {
    test('Query supports pagination', () async {
      when(() => mockApiService.getMoreVendors(page: 1, limit: 10)).thenAnswer(
        (_) async => VendorMocks.mockVendorsResponse(),
      );
      when(() => mockApiService.getMoreVendors(page: 2, limit: 10)).thenAnswer(
        (_) async =>
            VendorMocks.mockVendorPagination.map((v) => v.toJson()).toList(),
      );

      final query = repository.fetchInfiniteVendors();

      final firstPage = await query.result;

      expect(firstPage.data?.first, VendorMocks.vendors);

      final secondPage = await query.getNextPage();

      expect(secondPage?.data?.last, VendorMocks.mockVendorPagination);

      verify(() => mockApiService.getMoreVendors(page: 1, limit: 10)).called(1);
      verify(() => mockApiService.getMoreVendors(page: 2, limit: 10)).called(1);
    });

    test("Should stop pagination on empty response", () async {
      when(() => mockApiService.getMoreVendors(
          page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer(
        (_) async => VendorMocks.mockVendorsResponse(),
      );
      when(() => mockApiService.getMoreVendors(page: 2, limit: 10))
          .thenAnswer((_) async => []);

      final query = repository.fetchInfiniteVendors();
      final firstPage = await query.result;
      final secondPage = await query.getNextPage();
      final lastPage = secondPage?.data?.last;
      expect(firstPage.data?.first, VendorMocks.vendors);

      expect(secondPage?.status, QueryStatus.success);

      expect(lastPage, isEmpty);
    });
  });

  group("Infinite re-fetching", () {
    test('Query cache and refetch works correctly', () async {
      when(() => mockApiService.getMoreVendors(
              page: any(named: 'page'), limit: any(named: 'limit')))
          .thenAnswer((_) async => VendorMocks.mockVendorsResponse());

      final query = repository.fetchInfiniteVendors();
      await query.result;

      final cachedQuery = CachedQuery.instance.getQuery(
        VendorMocks.mockKeyVendors,
      );
      expect(cachedQuery, isNotNull);

      await query.refetch();
      verify(() => mockApiService.getMoreVendors(
          page: any(named: 'page'), limit: any(named: 'limit'))).called(2);
    });

    test('Query refreshes cache and refetches data', () async {
      when(() => mockApiService.getMoreVendors(
              page: any(named: 'page'), limit: any(named: 'limit')))
          .thenAnswer((_) async => VendorMocks.mockVendorsResponse());

      await repository.refreshVendors();
      verify(() => mockApiService.getMoreVendors(
          page: any(named: 'page'), limit: any(named: 'limit'))).called(1);

      final query = repository.fetchInfiniteVendors();
      await query.result;

      verify(() => mockApiService.getMoreVendors(
          page: any(named: 'page'), limit: any(named: 'limit'))).called(1);
    });
  });

  group("Infinite query args", () {
    test('Query uses cache when available', () async {
      when(() => mockApiService.getMoreVendors(
              page: any(named: 'page'), limit: any(named: 'limit')))
          .thenAnswer((_) async => VendorMocks.mockVendorsResponse());

      final queryFirst = repository.fetchInfiniteVendors();
      final resultFirst = await queryFirst.result;

      final querySecond = repository.fetchInfiniteVendors();

      final resultSecond = await querySecond.result;

      expect(resultFirst.data, resultSecond.data);
      verify(() => mockApiService.getMoreVendors(
          page: any(named: 'page'), limit: any(named: 'limit'))).called(1);
    });

    test('Query calls API when cache is expired', () async {
      when(() => mockApiService.getMoreVendors(
              page: any(named: 'page'), limit: any(named: 'limit')))
          .thenAnswer((_) async => VendorMocks.mockVendorsResponse());

      final query = repository.fetchInfiniteVendors();
      await query.result;
      CachedQuery.instance.deleteCache();

      verify(() => mockApiService.getMoreVendors(
          page: any(named: 'page'), limit: any(named: 'limit'))).called(1);
    });
  });

  group("Exception Handling - HTTP Status Code Handling", () {
    test("Should handle API timeout exception", () async {
      when(() => mockApiService.getMoreVendors(
          page: any(named: 'page'), limit: any(named: 'limit'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/vendors'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final query = repository.fetchInfiniteVendors();
      final result = await query.result;

      expect(result.status, QueryStatus.error);
      expect(result.error, isA<DioException>());
      expect((result.error as DioException).type,
          DioExceptionType.connectionTimeout);
    });
    test("Should handle API errors during pagination", () async {
      when(() => mockApiService.getMoreVendors(
          page: any(named: 'page'), limit: any(named: 'limit'))).thenAnswer(
        (_) async => VendorMocks.mockVendorsResponse(),
      );
      when(() => mockApiService.getMoreVendors(page: 2, limit: 10)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/vendors'),
          error: "Pagination error",
        ),
      );

      final query = repository.fetchInfiniteVendors();
      final firstPage = await query.result;
      final secondPage = await query.getNextPage();

      expect(firstPage.data?.isNotEmpty, true);
      expect(secondPage?.status, QueryStatus.error);
      expect(secondPage?.error, isA<DioException>());
    });
    test("Should handle 400 Bad Request", () async {
      when(() => mockApiService.getMoreVendors(
          page: any(named: 'page'), limit: any(named: 'limit'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/vendors'),
          response: Response(
            requestOptions: RequestOptions(path: '/vendors'),
            statusCode: 400,
            statusMessage: "Bad Request",
          ),
          error: "Invalid request",
        ),
      );

      final query = repository.fetchInfiniteVendors();
      final result = await query.result;

      expect(result.status, QueryStatus.error);
      expect(result.error, isA<DioException>());
      expect((result.error as DioException).response?.statusCode, 400);
    });

    test("Should handle 401 Unauthorized", () async {
      when(() => mockApiService.getMoreVendors(
          page: any(named: 'page'), limit: any(named: 'limit'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/vendors'),
          response: Response(
            requestOptions: RequestOptions(path: '/vendors'),
            statusCode: 401,
            statusMessage: "Unauthorized",
          ),
          error: "Authentication required",
        ),
      );

      final query = repository.fetchInfiniteVendors();
      final result = await query.result;

      expect(result.status, QueryStatus.error);
      expect(result.error, isA<DioException>());
      expect((result.error as DioException).response?.statusCode, 401);
    });

    test("Should handle 403 Forbidden", () async {
      when(() => mockApiService.getMoreVendors(
          page: any(named: 'page'), limit: any(named: 'limit'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/vendors'),
          response: Response(
            requestOptions: RequestOptions(path: '/vendors'),
            statusCode: 403,
            statusMessage: "Forbidden",
          ),
          error: "Access denied",
        ),
      );

      final query = repository.fetchInfiniteVendors();
      final result = await query.result;

      expect(result.status, QueryStatus.error);
      expect(result.error, isA<DioException>());
      expect((result.error as DioException).response?.statusCode, 403);
    });

    test("Should handle 404 Not Found", () async {
      when(() => mockApiService.getMoreVendors(
          page: any(named: 'page'), limit: any(named: 'limit'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/vendors'),
          response: Response(
            requestOptions: RequestOptions(path: '/vendors'),
            statusCode: 404,
            statusMessage: "Not Found",
          ),
          error: "Resource not found",
        ),
      );

      final query = repository.fetchInfiniteVendors();
      final result = await query.result;

      expect(result.status, QueryStatus.error);
      expect(result.error, isA<DioException>());
      expect((result.error as DioException).response?.statusCode, 404);
    });

    test("Should handle 500 Internal Server Error", () async {
      when(() => mockApiService.getMoreVendors(
          page: any(named: 'page'), limit: any(named: 'limit'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/vendors'),
          response: Response(
            requestOptions: RequestOptions(path: '/vendors'),
            statusCode: 500,
            statusMessage: "Internal Server Error",
          ),
          error: "Something went wrong",
        ),
      );

      final query = repository.fetchInfiniteVendors();
      final result = await query.result;

      expect(result.status, QueryStatus.error);
      expect(result.error, isA<DioException>());
      expect((result.error as DioException).response?.statusCode, 500);
    });
    test('Query handles API exceptions', () async {
      when(() => mockApiService.getMoreVendors(
          page: any(named: 'page'),
          limit: any(named: 'limit'))).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/vendors'),
        error: 'Server error',
      ));

      final query = repository.fetchInfiniteVendors();
      final result = await query.result;

      expect(result.status, QueryStatus.error);
      expect(result.error, isA<DioException>());
      verify(() => mockApiService.getMoreVendors(
          page: any(named: 'page'), limit: any(named: 'limit'))).called(1);
    });

    test("Should handle unknown status code", () async {
      when(() => mockApiService.getMoreVendors(
          page: any(named: 'page'), limit: any(named: 'limit'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/vendors'),
          response: Response(
            requestOptions: RequestOptions(path: '/vendors'),
            statusCode: 418,
            statusMessage: "I'm a teapot",
          ),
          error: "Unexpected status code",
        ),
      );

      final query = repository.fetchInfiniteVendors();
      final result = await query.result;

      expect(result.status, QueryStatus.error);
      expect(result.error, isA<DioException>());
      expect((result.error as DioException).response?.statusCode, 418);
    });
  });
  group("Infinite Query storage", () {
    final storage = MockStorage();
    setUpAll(() => CachedQuery.instance.config(storage: storage));
    tearDown(() {
      storage.deleteAll();
      CachedQuery.instance.deleteCache(key: VendorMocks.mockKeyVendors);
    });

    test("Should get Infinite Query initial data from storage before queryFn",
        () async {
      const key = "getInitial";
      const initialData = [3];
      final storedQuery = StoredQuery(
        key: key,
        data: initialData,
        createdAt: DateTime.now(),
      );
      storage.put(storedQuery);
      final query = repository.fetchInfiniteVendors();

      final output = <List<List<Vendor>>>[];
      query.stream.listen(
        expectAsync1(
          (event) {
            if (event.data != null && event.data!.isNotEmpty) {
              output.add(event.data!);
            }
            if (output.length == 1) {
              expect(output[0], initialData);
            }
          },
          max: 10,
        ),
      );
    });

    test("Can prevent queryFn being fired after fetch from storage", () async {
      const int numCalls = 0;
      const key = "query_no_fetch_storage";
      const data = 0;
      storage.deleteAll();
      storage.store.add(
        StoredQuery(
          key: key,
          data: [data],
          createdAt: DateTime.now(),
        ),
      );

      final query = repository.fetchInfiniteVendors();

      final res = await query.result;

      expect(numCalls, 0);
      expect(res.data, []);
    });

    test("Should invalidate cache after cacheDuration", () async {
      const cacheDuration = Duration(seconds: 5);

      storage.deleteAll();
      storage.put(
        StoredQuery(
          key: VendorMocks.mockKeyVendors,
          data: VendorMocks.expiredData,
          storageDuration: cacheDuration,
          createdAt: DateTime.now().subtract(const Duration(seconds: 6)),
        ),
      );

      when(() => mockApiService.getMoreVendors(page: 1, limit: 10)).thenAnswer(
        (_) async {
          return VendorMocks.newData.map((vendor) => vendor.toJson()).toList();
        },
      );

      final query = repository.fetchInfiniteVendors();
      final result = await query.result;

      expect(result.data?.length, VendorMocks.newData.length);
      expect(result.data?.first.first, VendorMocks.newData.first);

      verify(() => mockApiService.getMoreVendors(page: 1, limit: 10)).called(1);
    });
  });
}
