import 'package:bazar_books_app/example/example_cached_query/post_model.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:equatable/equatable.dart';

abstract class PostWithBuilderState extends Equatable {}

class PostWithBuilderInitial extends PostWithBuilderState {
  @override
  List<Object?> get props => [];
}

class PostWithBuilderSuccess extends PostWithBuilderState {
  final InfiniteQuery<List<PostModel>, int> postQuery;

  PostWithBuilderSuccess({required this.postQuery});

  @override
  List<Object?> get props => [postQuery];
}
