// ignore_for_file: unused_result

import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_app/features/home/bloc/product_bloc/product_bloc.dart';
import 'package:bazar_books_design/core/models/product_model/product_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../home_mocks.dart';

void main() {
  late ProductBloc productBloc;
  late MockHomeRepository productRepository;

  setUp(() {
    productRepository = MockHomeRepository();
    productBloc = ProductBloc(productRepository: productRepository);
  });

  tearDown(() {
    productBloc.close();
  });

  group('Test fetch products', () {
    blocTest<ProductBloc, FetchDataState<Product>>(
      '''
      Scenario: Fetch products successfully
        Given ProductBloc has initial state as FetchDataState.initial()
        When GetProductsEvent is added
        Then ProductBloc should emit [FetchDataState.loading(), FetchDataState.loaded(products)]''',
      build: () {
        when(() => productRepository.fetchProducts()).thenAnswer(
          (_) async => HomeMocks.mockProductList,
        );
        return productBloc;
      },
      act: (bloc) => bloc.add(GetProductsEvent()),
      expect: () => [
        const FetchDataState<Product>.loading(),
        isA<FetchDataState<Product>>()
          ..having(
            (entity) => entity,
            'View state FetchDataState.loaded(products)',
            equals(
              [
                HomeMocks.mockProductList,
              ],
            ),
          ),
      ],
    );
    blocTest<ProductBloc, FetchDataState<Product>>(
      '''
      Scenario: Fetch products with empty result
        Given ProductBloc has initial state as FetchDataState.initial()
        When GetProductsEvent is added
        Then ProductBloc should emit [FetchDataState.loading(), FetchDataState.loaded([])]
      ''',
      build: () {
        when(() => productRepository.fetchProducts())
            .thenAnswer((_) async => []);
        return productBloc;
      },
      act: (bloc) => bloc.add(GetProductsEvent()),
      expect: () => [
        const FetchDataState<Product>.loading(),
        isA<FetchDataState<Product>>()
          ..having(
            (entity) => entity,
            'View state FetchDataState.loaded(products)',
            equals(
              [],
            ),
          ),
      ],
    );

    blocTest<ProductBloc, FetchDataState<Product>>(
      '''
      Scenario: Error fetching products
        Given ProductBloc has initial state as FetchDataState.initial()
        When GetProductsEvent is added
        Then ProductBloc should emit [FetchDataState.loading(), FetchDataState.error("Failed to load products")]
      ''',
      build: () {
        when(() => productRepository.fetchProducts())
            .thenThrow(Exception('Failed to load products'));
        return productBloc;
      },
      act: (bloc) => bloc.add(GetProductsEvent()),
      expect: () => [
        const FetchDataState<Product>.loading(),
        isA<FetchDataState<Product>>()
          ..having(
            (entity) => entity,
            'Failed to load products',
            equals(
              [
                const FetchDataState<Product>.error('Failed to load products'),
              ],
            ),
          ),
      ],
    );
  });
}
