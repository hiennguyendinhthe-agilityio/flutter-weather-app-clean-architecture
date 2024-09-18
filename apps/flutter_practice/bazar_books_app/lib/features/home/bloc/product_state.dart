part of 'product_bloc.dart';

abstract class GetProductsState extends Equatable {
  const GetProductsState();
  @override
  List<Object> get props => [];
}

class ProductsInitial extends GetProductsState {}

class GetProductsStateLoading extends GetProductsState {
  const GetProductsStateLoading();
}

class GetProductsStateLoaded extends GetProductsState {
  final List<Product> products;
  const GetProductsStateLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class GetProductsStateError extends GetProductsState {
  const GetProductsStateError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
