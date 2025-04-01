part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<Product> products;
  final String errorMessage;

  final List<String> history;

  const SearchState({
    this.status = SearchStatus.initial,
    this.products = const [],
    this.errorMessage = '',
    this.history = const [],
  });

  SearchState copyWith({
    SearchStatus? status,
    List<Product>? products,
    String? errorMessage,
    List<String>? history,
  }) {
    return SearchState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
      history: history ?? this.history,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        errorMessage,
        history,
      ];
}
