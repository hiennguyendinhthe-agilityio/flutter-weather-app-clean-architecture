import 'package:bazar_books_app/features/profile/bloc/favorite/favorite_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../profile_mock.dart';

void main() {
  late MockFavoriteRepository mockRepository;
  setUp(() {
    mockRepository = MockFavoriteRepository();
  });

  group('FavoriteBloc', () {
    blocTest<FavoriteBloc, FavoriteState>(
      'emits [loading, success] state when GetFavoriteProducts is added and data is fetched successfully',
      setUp: () {
        final mockQueryState = MockQueryState();
        when(() => mockQueryState.stream)
            .thenAnswer((_) => Stream.fromIterable([
                  QueryState(
                    data: [],
                    status: QueryStatus.loading,
                    timeCreated: DateTime.now(),
                  ),
                  QueryState(
                    data: ProfileMock.mockProductList,
                    status: QueryStatus.success,
                    timeCreated: DateTime.now(),
                  ),
                ]));
        when(() => mockRepository.getFavorites(ProfileMock.userId))
            .thenReturn(mockQueryState);
      },
      build: () => FavoriteBloc(mockRepository),
      act: (bloc) => bloc.add(GetFavoriteProducts(ProfileMock.userId)),
      expect: () => [
        const FavoriteState(status: FavoriteStatus.loading),
        FavoriteState(
          status: FavoriteStatus.success,
          favorites: ProfileMock.mockProductList,
        ),
      ],
    );

    blocTest<FavoriteBloc, FavoriteState>(
      'emits [loading, failure] when GetFavoriteProducts is added and API throws an error',
      setUp: () {
        final mockQueryState = MockQueryState();
        when(() => mockQueryState.stream).thenAnswer((_) => Stream.error(
              DioException(
                requestOptions: RequestOptions(),
              ),
            ));
        when(() => mockRepository.getFavorites(ProfileMock.userId))
            .thenReturn(mockQueryState);
      },
      build: () => FavoriteBloc(mockRepository),
      act: (bloc) => bloc.add(GetFavoriteProducts(ProfileMock.userId)),
      expect: () => [
        const FavoriteState(
          status: FavoriteStatus.failure,
          errorMessage: ProfileMock.errorMock,
        ),
      ],
    );

    blocTest<FavoriteBloc, FavoriteState>(
      'emits [loading, success] with empty favorites list when API returns empty list',
      setUp: () {
        final mockQueryState = MockQueryState();
        when(() => mockQueryState.stream)
            .thenAnswer((_) => Stream.fromIterable([
                  QueryState(
                    data: [],
                    status: QueryStatus.loading,
                    timeCreated: DateTime.now(),
                  ),
                  QueryState(
                    data: [],
                    status: QueryStatus.success,
                    timeCreated: DateTime.now(),
                  ),
                ]));
        when(() => mockRepository.getFavorites(ProfileMock.userId))
            .thenReturn(mockQueryState);
      },
      build: () => FavoriteBloc(mockRepository),
      act: (bloc) => bloc.add(GetFavoriteProducts(ProfileMock.userId)),
      expect: () => [
        const FavoriteState(
          status: FavoriteStatus.loading,
        ),
        const FavoriteState(
          status: FavoriteStatus.success,
        ),
      ],
    );

    blocTest<FavoriteBloc, FavoriteState>(
      'emits no states when GetFavoriteProducts is added but stream emits no values',
      setUp: () {
        final mockQueryState = MockQueryState();
        when(() => mockQueryState.stream)
            .thenAnswer((_) => const Stream.empty());
        when(() => mockRepository.getFavorites(ProfileMock.userId))
            .thenReturn(mockQueryState);
      },
      build: () => FavoriteBloc(mockRepository),
      act: (bloc) => bloc.add(GetFavoriteProducts(ProfileMock.userId)),
      expect: () => [],
    );

    blocTest<FavoriteBloc, FavoriteState>(
      'emits [loading, success] once when stream emits duplicate success values',
      setUp: () {
        final mockQueryState = MockQueryState();
        when(() => mockQueryState.stream)
            .thenAnswer((_) => Stream.fromIterable([
                  QueryState(
                    data: ProfileMock.mockProductList,
                    status: QueryStatus.loading,
                    timeCreated: DateTime.now(),
                  ),
                  QueryState(
                    data: ProfileMock.mockProductList,
                    status: QueryStatus.success,
                    timeCreated: DateTime.now(),
                  ),
                  QueryState(
                    data: ProfileMock.mockProductList,
                    status: QueryStatus.success,
                    timeCreated: DateTime.now(),
                  ),
                ]));
        when(() => mockRepository.getFavorites(ProfileMock.userId))
            .thenReturn(mockQueryState);
      },
      build: () => FavoriteBloc(mockRepository),
      act: (bloc) => bloc.add(GetFavoriteProducts(ProfileMock.userId)),
      expect: () => [
        FavoriteState(
          status: FavoriteStatus.loading,
          favorites: ProfileMock.mockProductList,
        ),
        FavoriteState(
          status: FavoriteStatus.success,
          favorites: ProfileMock.mockProductList,
        ),
      ],
    );

    blocTest<FavoriteBloc, FavoriteState>(
      'emits [loading, failure] when stream emits unexpected status',
      setUp: () {
        final mockQueryState = MockQueryState();
        when(() => mockQueryState.stream)
            .thenAnswer((_) => Stream.fromIterable([
                  QueryState(
                    status: QueryStatus.loading,
                    timeCreated: DateTime.now(),
                  ),
                  QueryState(
                    error: DioException(
                      requestOptions: RequestOptions(),
                    ),
                    status: QueryStatus.error,
                    timeCreated: DateTime.now(),
                  ),
                ]));
        when(() => mockRepository.getFavorites(ProfileMock.userId))
            .thenReturn(mockQueryState);
      },
      build: () => FavoriteBloc(mockRepository),
      act: (bloc) => bloc.add(GetFavoriteProducts(ProfileMock.userId)),
      expect: () => [
        const FavoriteState(
          status: FavoriteStatus.loading,
        ),
        const FavoriteState(
          status: FavoriteStatus.failure,
          errorMessage: ProfileMock.errorMock,
        ),
      ],
    );
  });
}
