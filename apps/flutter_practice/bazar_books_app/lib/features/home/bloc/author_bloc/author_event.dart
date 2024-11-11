part of 'author_bloc.dart';

sealed class AuthorEvent {
  List<Object?> get props => [];
}

class GetAuthorsEvent extends AuthorEvent {}

class FetchAuthorProfileEvent extends AuthorEvent {
  final String id;

  FetchAuthorProfileEvent(this.id);

  @override
  List<Object?> get props => [id];
}
