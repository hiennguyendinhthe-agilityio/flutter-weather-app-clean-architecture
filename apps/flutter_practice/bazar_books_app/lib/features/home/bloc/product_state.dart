part of 'product_bloc.dart';

@immutable
sealed class GetProductsState {}

class GetProductsStateInitial extends GetProductsState {
  GetProductsStateInitial();
}

class GetProductsStateLoading extends GetProductsState {
  GetProductsStateLoading();
}

class GetProductsStateLoaded extends GetProductsState {
  GetProductsStateLoaded(this.products);

  final List<Product> products;

  List<Object?> get props => [products];
}

class GetProductsStateError extends GetProductsState {
  GetProductsStateError({
    required this.message,
  });

  final String message;

  List<Object?> get props => [message];
}
