part of 'product_bloc.dart';

sealed class ProductEvent {
  List<Object?> get props => [];
}

class GetProductsEvent extends ProductEvent {}
