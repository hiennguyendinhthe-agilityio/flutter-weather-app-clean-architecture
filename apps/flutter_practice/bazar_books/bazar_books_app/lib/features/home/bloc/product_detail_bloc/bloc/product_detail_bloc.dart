// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_app/features/home/data/product_repository/product_repository.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository productRepository;
  ProductDetailBloc({required this.productRepository})
      : super(const ProductDetailState(
          fetchDataState: FetchDataState.initial(),
          isFavorite: false,
          quantity: 1,
        )) {
    on<FetchProductDetailsEvent>(_onFetchProductDetails);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<UpdateAmountEvent>(_onUpdateAmount);
    on<AddProductToFavoritesEvent>(_onAddFavoriteProduct);
  }

  void _onFetchProductDetails(
      FetchProductDetailsEvent event, Emitter<ProductDetailState> emit) async {
    emit(state.copyWith(fetchDataState: const FetchDataState.loading()));
    try {
      final product = await productRepository.fetchProductDetails(event.id);
      emit(state.copyWith(
        fetchDataState: FetchDataState.loaded([product]),
      ));
    } catch (e) {
      emit(state.copyWith(
        fetchDataState: FetchDataState.error(e.toString()),
      ));
    }
  }

  void _onToggleFavorite(
      ToggleFavoriteEvent event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }

  void _onUpdateAmount(
      UpdateAmountEvent event, Emitter<ProductDetailState> emit) {
    final newAmount = event.newAmount < 1 ? 1 : event.newAmount;
    emit(state.copyWith(amount: newAmount));
  }

  Future<void> _onAddFavoriteProduct(
    AddProductToFavoritesEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    final mutation = productRepository.createFavorite(event.product);
    mutation.mutate(event.product);
  }
}
