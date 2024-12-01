// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_app/features/category/bloc/data_state.dart';
import 'package:bazar_books_app/features/category/data/category_repository.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_event.dart';

class CategoryBloc extends Bloc<CategoryEvent, FetchDataState<Product>> {
  final CategoryRepository categoryRepository;
  CategoryBloc({required this.categoryRepository})
      : super(const FetchDataState<Product>.initial()) {
    on<GetCategoryEvent>(_onGetProducts);
  }

  Future<void> _onGetProducts(
      GetCategoryEvent event, Emitter<FetchDataState<Product>> emit) async {
    emit(const FetchDataState<Product>.loading());

    try {
      final products = await categoryRepository.fetchCategory(event.category);

      emit(FetchDataState<Product>.loaded(products));
    } catch (e) {
      emit(FetchDataState<Product>.error(
          ErrorHandler.handle(e).failure.message));
    }
  }
}
