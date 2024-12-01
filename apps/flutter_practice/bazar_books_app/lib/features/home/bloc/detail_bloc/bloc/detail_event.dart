part of 'detail_bloc.dart';

@immutable
sealed class DetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchProductDetailsEvent extends DetailEvent {
  final String? id;

  FetchProductDetailsEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleFavoriteEvent extends DetailEvent {}

class UpdateAmountEvent extends DetailEvent {
  final int newAmount;

  UpdateAmountEvent(this.newAmount);

  @override
  List<Object?> get props => [newAmount];
}
