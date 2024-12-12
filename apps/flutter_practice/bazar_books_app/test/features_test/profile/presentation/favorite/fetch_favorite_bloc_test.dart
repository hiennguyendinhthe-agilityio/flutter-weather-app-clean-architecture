import 'package:bazar_books_app/features/profile/bloc/favorite/favorite_bloc.dart';
import 'package:bazar_books_app/features/profile/bloc/favorite/favorite_event.dart';
import 'package:bazar_books_app/features/profile/bloc/favorite/favorite_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../profile_mock.dart';

void main() {
  group('FavoriteBloc', () {
    late FavoriteBloc bloc;
    late MockProductService mockProductService;
    late MockProductRepository mockProductRepository;

    setUp(() {
      mockProductService = MockProductService();
      mockProductRepository = MockProductRepository();
      bloc = FavoriteBloc(mockProductService, mockProductRepository);
    });

    tearDown(() {
      bloc.close();
    });

    blocTest<FavoriteBloc, FavoriteState>(
      'emits [FavoriteInitial, FavoriteSuccess] when fetchProducts succeeds with data',
      build: () {
        when(() => mockProductRepository.fetchProducts())
            .thenAnswer((_) async => [ProfileMock.mockProduct]);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadFavoritesEvent()),
      expect: () => [
        const FavoriteInitial([]),
        FavoriteSuccess([ProfileMock.mockProduct]),
      ],
    );

    blocTest<FavoriteBloc, FavoriteState>(
      'emits [FavoriteInitial, FavoriteError] when fetchProducts throws an error',
      build: () {
        when(() => mockProductRepository.fetchProducts())
            .thenThrow(ProfileMock.mockDioError);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadFavoritesEvent()),
      expect: () => [
        const FavoriteInitial([]),
        const FavoriteError('Not found error'),
      ],
      verify: (_) {
        verify(() => mockProductRepository.fetchProducts()).called(1);
      },
    );
  });
}
