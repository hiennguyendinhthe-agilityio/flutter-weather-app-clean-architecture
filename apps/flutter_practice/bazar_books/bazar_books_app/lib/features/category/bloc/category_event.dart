part of 'category_bloc.dart';

sealed class CategoryEvent {
  List<Object?> get props => [];
}

class GetCategoryEvent extends CategoryEvent {
  final String category;
  GetCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class FilterCategoryEvent extends CategoryEvent {
  final String category;

  FilterCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}
