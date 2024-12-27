import 'package:bazar_books_app/features/category/categori_search/bloc/search_bloc.dart';
import 'package:bazar_books_design/core/models/product_model/product_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../category_mock.dart';

void main() {
  late MockCategoryRepository mockCategoryRepository;
  late SearchBloc searchBloc;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    searchBloc = SearchBloc(searchRepository: mockCategoryRepository);
  });

  tearDown(() {
    searchBloc.close();
  });

  group('SearchBloc', () {
    const query = 'product';
    final products = [
      Product(id: '1', title: 'Product 1'),
      Product(id: '2', title: 'Product 2'),
      Product(id: '3', title: 'Product 3'),
    ];

    blocTest<SearchBloc, SearchState>(
      'emits [loading, success] when products are fetched successfully',
      build: () {
        when(() => mockCategoryRepository.fetchProducts())
            .thenAnswer((_) async => products);
        return searchBloc;
      },
      act: (bloc) => bloc.add(const PerformSearchEvent(query)),
      expect: () => [
        const SearchState(status: SearchStatus.loading),
        SearchState(
          status: SearchStatus.success,
          products: products,
        ),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [loading, failure] when an error occurs',
      build: () {
        when(() => mockCategoryRepository.fetchProducts())
            .thenThrow(CategoryMock.mockDioError);
        return searchBloc;
      },
      act: (bloc) => bloc.add(const PerformSearchEvent(query)),
      expect: () => [
        const SearchState(status: SearchStatus.loading),
        const SearchState(
          status: SearchStatus.failure,
          errorMessage: 'Not found error', // Update based on ErrorHandler
        ),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'correctly adds a query to the search history',
      build: () => searchBloc,
      act: (bloc) => bloc.add(const AddToSearchHistoryEvent(query)),
      expect: () => [
        const SearchState(history: [query]),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'removes the oldest query if history exceeds 3 items',
      build: () => searchBloc,
      act: (bloc) {
        bloc.add(const AddToSearchHistoryEvent('query 1'));
        bloc.add(const AddToSearchHistoryEvent('query 2'));
        bloc.add(const AddToSearchHistoryEvent('query 3'));
        bloc.add(const AddToSearchHistoryEvent('query 4'));
      },
      expect: () => [
        const SearchState(history: ['query 1']),
        const SearchState(history: ['query 2', 'query 1']),
        const SearchState(history: ['query 3', 'query 2', 'query 1']),
        const SearchState(history: ['query 4', 'query 3', 'query 2']),
      ],
    );
  });
}
