import 'package:bazar_books_design/core/apis/api_sercvice.dart';
import 'package:bazar_books_design/core/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, GetProductsState> {
  ProductBloc(this.productApi) : super(GetProductsStateInitial()) {
    on<GetProductsEvent>(_onGetProducts);
  }
  final ApiService productApi;

  Future<void> _onGetProducts(
      GetProductsEvent event, Emitter<GetProductsState> emit) async {
    emit(GetProductsStateLoading());

    try {
      final products = await productApi.fetchProducts();
      emit(GetProductsStateLoaded(products));
    } catch (e) {
      emit(
        GetProductsStateError(
          message: 'Failed to fetch products',
        ),
      );
    }
  }
}
