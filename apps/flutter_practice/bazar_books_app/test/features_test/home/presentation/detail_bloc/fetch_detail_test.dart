import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_app/features/home/bloc/product_detail_bloc/bloc/product_detail_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../home_mocks.dart';

void main() {
  late ProductDetailBloc detailBloc;
  late MockHomeRepository productRepository;

  setUp(() {
    productRepository = MockHomeRepository();
    detailBloc = ProductDetailBloc(productRepository: productRepository);
  });
  tearDown(() {
    detailBloc.close();
  });
  group('Test fetch product details', () {
    blocTest<ProductDetailBloc, ProductDetailState>(
      '''
      Scenario: Fetch product details successfully
        Given DetailBloc has initial state
        When FetchProductDetailsEvent is added
        Then DetailBloc should emit [loading state, loaded state with product]
      ''',
      build: () {
        when(() => productRepository.fetchProductDetails('1')).thenAnswer(
          (_) async => HomeMocks.mockProductDetail,
        );
        return detailBloc;
      },
      act: (bloc) => bloc.add(FetchProductDetailsEvent('1')),
      expect: () => [
        detailBloc.state.copyWith(
          fetchDataState: const FetchDataState.loading(),
        ),
        detailBloc.state.copyWith(
          fetchDataState: FetchDataState.loaded([
            HomeMocks.mockProductDetail,
          ]),
        ),
      ],
    );

    blocTest<ProductDetailBloc, ProductDetailState>(
      '''
      Scenario: Error fetching product details
        Given DetailBloc has initial state
        When FetchProductDetailsEvent is added and an error occurs
        Then DetailBloc should emit [loading state, error state]
      ''',
      build: () {
        when(() => productRepository.fetchProductDetails('1'))
            .thenThrow(Exception('Failed to load product details'));
        return detailBloc;
      },
      act: (bloc) => bloc.add(FetchProductDetailsEvent('1')),
      expect: () => [
        detailBloc.state
            .copyWith(fetchDataState: const FetchDataState.loading()),
        detailBloc.state.copyWith(
          fetchDataState: const FetchDataState.error(
              'Exception: Failed to load product details'),
        ),
      ],
    );

    blocTest<ProductDetailBloc, ProductDetailState>(
      '''
      Scenario: Toggle favorite status
        Given DetailBloc has initial favorite status as false
        When ToggleFavoriteEvent is added
        Then DetailBloc should emit a state with favorite status toggled to true
      ''',
      build: () => detailBloc,
      act: (bloc) => bloc.add(ToggleFavoriteEvent()),
      seed: () => detailBloc.state.copyWith(isFavorite: false),
      expect: () => [
        detailBloc.state.copyWith(isFavorite: true),
      ],
    );

    blocTest<ProductDetailBloc, ProductDetailState>(
      '''
      Scenario: Update product quantity
        Given DetailBloc has initial quantity of 1
        When UpdateAmountEvent with new amount 5 is added
        Then DetailBloc should emit a state with quantity updated to 5
      ''',
      build: () => detailBloc,
      act: (bloc) => bloc.add(UpdateAmountEvent(5)),
      expect: () => [
        detailBloc.state.copyWith(amount: 5),
      ],
    );

    blocTest<ProductDetailBloc, ProductDetailState>(
      '''
      Scenario: Update product quantity with a value less than 1
        Given DetailBloc has initial quantity of 1
        When UpdateAmountEvent with new amount 0 is added
        Then DetailBloc should emit a state with quantity set to 1 (minimum allowed)
      ''',
      build: () => detailBloc,
      act: (bloc) => bloc.add(UpdateAmountEvent(0)),
      expect: () => [
        detailBloc.state.copyWith(amount: 1),
      ],
    );
  });
}
