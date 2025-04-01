// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_app/features/category/data/category_repository.dart';
import 'package:bazar_books_design/core/models/product_model/product_model.dart';
import 'package:bazar_books_design/core/network/error_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final CategoryRepository searchRepository;

  SearchBloc({required this.searchRepository}) : super(const SearchState()) {
    on<PerformSearchEvent>(_onPerformSearch);
    on<AddToSearchHistoryEvent>(_onAddToSearchHistory);
  }

  Future<void> _onPerformSearch(
      PerformSearchEvent event, Emitter<SearchState> emit) async {
    emit(state.copyWith(status: SearchStatus.loading));

    try {
      final products = await searchRepository.fetchProducts();
      final filteredProducts = products
          .where((product) =>
              product.title
                  ?.toLowerCase()
                  .contains(event.query.toLowerCase()) ??
              true)
          .toList();

      emit(state.copyWith(
        status: SearchStatus.success,
        products: filteredProducts,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: SearchStatus.failure,
            errorMessage: ErrorHandler.handle(e).failure.message),
      );
    }
  }

  void _onAddToSearchHistory(
      AddToSearchHistoryEvent event, Emitter<SearchState> emit) {
    final updatedHistory = List<String>.from(state.history);

    if (updatedHistory.contains(event.query)) {
      updatedHistory.remove(event.query);
    }

    updatedHistory.insert(0, event.query);

    if (updatedHistory.length > 3) {
      updatedHistory.removeLast();
    }

    emit(state.copyWith(history: updatedHistory));
  }
}
