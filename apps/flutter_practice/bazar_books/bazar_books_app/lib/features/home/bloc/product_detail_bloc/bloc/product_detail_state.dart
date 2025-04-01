part of 'product_detail_bloc.dart';

class ProductDetailState extends Equatable {
  final FetchDataState<Product> fetchDataState;
  final bool isFavorite;
  final int quantity;

  const ProductDetailState({
    required this.fetchDataState,
    required this.isFavorite,
    required this.quantity,
  });

  ProductDetailState copyWith({
    FetchDataState<Product>? fetchDataState,
    bool? isFavorite,
    int? amount,
  }) {
    return ProductDetailState(
      fetchDataState: fetchDataState ?? this.fetchDataState,
      isFavorite: isFavorite ?? this.isFavorite,
      quantity: amount ?? quantity,
    );
  }

  @override
  List<Object?> get props => [fetchDataState, isFavorite, quantity];
}
