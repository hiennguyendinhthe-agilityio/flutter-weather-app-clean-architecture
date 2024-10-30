import 'dart:async';

import 'package:bazar_books_app/example/example_cached_query/post_repository.dart';
import 'package:bazar_books_app/example/example_cached_query/post_with_builder_event.dart';
import 'package:bazar_books_app/example/example_cached_query/post_with_builder_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostWithBuilderBloc
    extends Bloc<PostWithBuilderEvent, PostWithBuilderState> {
  final _repo = PostRepository();

  PostWithBuilderBloc() : super(PostWithBuilderInitial()) {
    on<PostsWithBuilderFetched>(_onPostsFetched);
    on<PostsWithBuilderNextPage>(_onPostsNextPage);
  }

  FutureOr<void> _onPostsFetched(
    PostsWithBuilderFetched _,
    Emitter<PostWithBuilderState> emit,
  ) {
    final query = _repo.getPosts();
    emit(PostWithBuilderSuccess(postQuery: query));
  }

  void _onPostsNextPage(
      PostWithBuilderEvent _, Emitter<PostWithBuilderState> __) {
    // No need to store the query in a variable as calling getPosts() again will
    // retrieve the same instance of infinite query.
    _repo.getPosts().getNextPage();
  }
}
