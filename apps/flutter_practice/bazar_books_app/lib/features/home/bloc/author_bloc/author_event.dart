part of 'author_bloc.dart';

sealed class AuthorEvent {
  List<Object?> get props => [];
}

class GetProductsEvent extends AuthorEvent {}
