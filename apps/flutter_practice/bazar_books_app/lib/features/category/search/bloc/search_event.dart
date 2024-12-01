part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class PerformSearchEvent extends SearchEvent {
  final String query;

  const PerformSearchEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class AddToSearchHistoryEvent extends SearchEvent {
  final String query;

  const AddToSearchHistoryEvent(this.query);

  @override
  List<Object?> get props => [query];
}
