part of 'detail_bloc.dart';

class DetailState extends Equatable {
  final FetchDataState<Product> fetchDataState;
  final bool isFavorite;
  final int quantity;

  const DetailState({
    required this.fetchDataState,
    required this.isFavorite,
    required this.quantity,
  });

  DetailState copyWith({
    FetchDataState<Product>? fetchDataState,
    bool? isFavorite,
    int? amount,
  }) {
    return DetailState(
      fetchDataState: fetchDataState ?? this.fetchDataState,
      isFavorite: isFavorite ?? this.isFavorite,
      quantity: amount ?? quantity,
    );
  }

  @override
  List<Object?> get props => [fetchDataState, isFavorite, quantity];
}
