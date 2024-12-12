import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:equatable/equatable.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();
}

class FavoriteInitial extends FavoriteState {
  final List<Product> favorites;

  const FavoriteInitial(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class FavoriteLoading extends FavoriteState {
  const FavoriteLoading();

  @override
  List<Object> get props => [];
}

class FavoriteError extends FavoriteState {
  final String errorMessage;

  const FavoriteError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FavoriteSuccess extends FavoriteState {
  final List<Product> favorites;

  const FavoriteSuccess(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class FavoriteSuccessId extends FavoriteState {
  final List<Product> products;

  const FavoriteSuccessId(this.products);

  @override
  List<Object> get props => [products];
}
