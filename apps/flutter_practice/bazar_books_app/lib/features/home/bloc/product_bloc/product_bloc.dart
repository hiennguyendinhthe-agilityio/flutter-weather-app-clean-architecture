// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_app/features/home/data/product_repository/product_repository.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_event.dart';

class ProductBloc extends Bloc<ProductEvent, FetchDataState<Product>> {
  final ProductRepository productRepository;
  ProductBloc({required this.productRepository})
      : super(const FetchDataState<Product>.initial()) {
    on<GetProductsEvent>(_onGetProducts);
  }

  Future<void> _onGetProducts(
      GetProductsEvent event, Emitter<FetchDataState<Product>> emit) async {
    emit(const FetchDataState<Product>.loading());

    try {
      final products = await productRepository.fetchProducts();

      emit(FetchDataState<Product>.loaded(products));
    } catch (e) {
      emit(FetchDataState<Product>.error(
          ErrorHandler.handle(e).failure.message));
    }
  }
}
