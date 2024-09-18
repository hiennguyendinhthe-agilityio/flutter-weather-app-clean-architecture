// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_design/core/apis/api_sercvice.dart';
import 'package:bazar_books_design/core/models/product_model.dart';
import 'package:bazar_books_design/core/network/error_handler.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, GetProductsState> {
  ProductBloc(this.productApi) : super(ProductsInitial()) {
    on<GetProductsEvent>(_onGetProducts);
  }

  final ApiService productApi;

  Future<void> _onGetProducts(
      GetProductsEvent event, Emitter<GetProductsState> emit) async {
    emit(const GetProductsStateLoading());

    try {
      final products = await productApi.fetchProducts();
      emit(GetProductsStateLoaded(products: products));
    } catch (e) {
      emit(
        GetProductsStateError(
          ErrorHandler.handle(e).failure.message,
        ),
      );
    }
  }
}
