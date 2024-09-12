part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {
  List<Object?> get props => [];
}

class GetProductsEvent extends ProductEvent {}
