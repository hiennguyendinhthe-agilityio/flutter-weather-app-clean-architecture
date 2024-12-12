import 'package:bazar_books_design/core/models/product_model/product_model.dart';
import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];

  get product => null;
}

class LoadFavoritesEvent extends FavoriteEvent {}

class AddToFavoritesEvent extends FavoriteEvent {
  @override
  final Product product;

  const AddToFavoritesEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveFromFavoritesEvent extends FavoriteEvent {
  @override
  final Product product;

  const RemoveFromFavoritesEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class LoadProductByIdEvent extends FavoriteEvent {
  final int productId;

  const LoadProductByIdEvent(this.productId);
}
