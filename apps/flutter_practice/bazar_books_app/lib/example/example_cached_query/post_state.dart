import 'package:bazar_books_app/example/example_cached_query/post_model.dart';
import 'package:equatable/equatable.dart';

enum PostStatus { loading, initial, success }

class PostState extends Equatable {
  final PostStatus status;
  final List<PostModel>? posts;
  final bool hasReachedMax;

  const PostState({
    this.status = PostStatus.initial,
    this.posts,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [posts, status, hasReachedMax];

  PostState copyWith({
    PostStatus? status,
    List<PostModel>? posts,
    bool? hasReachedMax,
  }) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
