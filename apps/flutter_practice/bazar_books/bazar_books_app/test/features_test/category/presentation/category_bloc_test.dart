import 'package:bazar_books_app/features/category/bloc/category_bloc.dart';
import 'package:bazar_books_app/features/category/bloc/data_state.dart';
import 'package:bazar_books_design/core/models/product_model/product_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../category_mock.dart';

void main() {
  late CategoryBloc categoryBloc;
  late MockCategoryRepository mockCategoryRepository;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    categoryBloc = CategoryBloc(categoryRepository: mockCategoryRepository);
  });

  tearDown(() {
    categoryBloc.close();
  });
  group('CategoryBloc', () {
    const category = 'electronics'; // Example category
    final products = [Product(id: '1', title: 'Product 1')]; // Example product

    blocTest<CategoryBloc, FetchDataState<Product>>(
      'emits [loading, loaded] when products are fetched successfully',
      build: () {
        when(() => mockCategoryRepository.fetchFilterCategory(category))
            .thenAnswer((_) async => products);
        return categoryBloc;
      },
      act: (bloc) => bloc.add(GetCategoryEvent(category)),
      expect: () => [
        const FetchDataState<Product>.loading(),
        FetchDataState<Product>.loaded(products),
      ],
    );

    blocTest<CategoryBloc, FetchDataState<Product>>(
      'emits [loading, error] when an error occurs',
      build: () {
        when(() => mockCategoryRepository.fetchFilterCategory(category))
            .thenThrow(
          CategoryMock.mockDioError,
        );
        return categoryBloc;
      },
      act: (bloc) => bloc.add(GetCategoryEvent(category)),
      expect: () => [
        const FetchDataState<Product>.loading(),
        const FetchDataState<Product>.error('Not found error'),
      ],
    );
  });
}
