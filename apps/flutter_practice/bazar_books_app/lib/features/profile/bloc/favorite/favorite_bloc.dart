import 'package:bazar_books_app/features/home/data/product_repository/product_repository.dart';
import 'package:bazar_books_app/features/profile/bloc/favorite/favorite_event.dart';
import 'package:bazar_books_app/features/profile/bloc/favorite/favorite_state.dart';
import 'package:bazar_books_design/core/network/error_handler.dart';
import 'package:bazar_books_design/db/product_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final ProductService productService;
  final ProductRepository productRepository;

  FavoriteBloc(this.productService, this.productRepository)
      : super(const FavoriteInitial([])) {
    on<LoadFavoritesEvent>(_onFetchFavorites);
  }

  Future<void> _onFetchFavorites(
      FavoriteEvent event, Emitter<FavoriteState> emit) async {
    emit(const FavoriteInitial([]));

    try {
      final favorite = await productRepository.fetchProducts();

      if (favorite.isEmpty) {
        final currentFavorites = (state as FavoriteInitial).favorites;
        emit(FavoriteInitial([...currentFavorites, event.product]));
      } else {
        emit(FavoriteSuccess(favorite));
      }
    } catch (e) {
      emit(FavoriteError(ErrorHandler.handle(e).failure.message));
    }
  }
}
