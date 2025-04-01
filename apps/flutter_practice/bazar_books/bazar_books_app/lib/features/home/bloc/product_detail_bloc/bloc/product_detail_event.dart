part of 'product_detail_bloc.dart';

@immutable
sealed class ProductDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchProductDetailsEvent extends ProductDetailEvent {
  final String? id;

  FetchProductDetailsEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleFavoriteEvent extends ProductDetailEvent {}

class UpdateAmountEvent extends ProductDetailEvent {
  final int newAmount;

  UpdateAmountEvent(this.newAmount);

  @override
  List<Object?> get props => [newAmount];
}

class AddProductToFavoritesEvent extends ProductDetailEvent {
  final Product product;

  AddProductToFavoritesEvent(this.product);

  @override
  List<Object?> get props => [product];
}
