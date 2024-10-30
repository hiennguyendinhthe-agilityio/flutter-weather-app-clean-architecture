import 'dart:async';

import 'package:bazar_books_app/example/example_cached_query/post_event.dart';
import 'package:bazar_books_app/example/example_cached_query/post_model.dart';
import 'package:bazar_books_app/example/example_cached_query/post_repository.dart';
import 'package:bazar_books_app/example/example_cached_query/post_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final _repo = PostRepository();

  PostBloc() : super(const PostState()) {
    on<PostsFetched>(_onPostsFetched, transformer: restartable());
    on<PostsNextPage>(_onPostsNextPage);
  }

  FutureOr<void> _onPostsFetched(
    PostsFetched event,
    Emitter<PostState> emit,
  ) {
    final query = _repo.getPosts();

    return emit.forEach<InfiniteQueryState<List<PostModel>>>(query.stream,
        onData: (queryState) {
      return state.copyWith(
        posts: queryState.data?.expand((page) => page).toList() ?? [],
        status: queryState.status == QueryStatus.loading
            ? PostStatus.loading
            : PostStatus.success,
        hasReachedMax: queryState.hasReachedMax,
      );
    });
  }

  void _onPostsNextPage(PostEvent _, Emitter<PostState> __) {
    _repo.getPosts().getNextPage();
  }
}
