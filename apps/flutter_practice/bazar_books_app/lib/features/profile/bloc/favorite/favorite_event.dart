part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class GetFavoriteProducts extends FavoriteEvent {
  final String userId;

  const GetFavoriteProducts(this.userId);

  @override
  List<Object> get props => [userId];
}
