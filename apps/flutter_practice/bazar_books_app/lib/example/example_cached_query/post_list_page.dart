import 'package:bazar_books_app/example/example_cached_query/post_bloc.dart';
import 'package:bazar_books_app/example/example_cached_query/post_event.dart';
import 'package:bazar_books_app/example/example_cached_query/post_state.dart';
import 'package:bazar_books_app/example/example_cached_query/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              return SizedBox(
                width: 150,
                child: Stack(
                  children: [
                    if (state.status == PostStatus.loading)
                      const Align(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    const Center(
                      child: Text('Posts'),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        body: const _List(),
      ),
    );
  }
}

class _List extends StatefulWidget {
  const _List();

  @override
  State<_List> createState() => _ListState();
}

class _ListState extends State<_List> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PostBloc>().add(PostsFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        final posts = state.posts;
        if (posts != null) {
          return ListView.builder(
            controller: _scrollController,
            itemCount:
                !state.hasReachedMax && state.status == PostStatus.loading
                    ? posts.length + 1
                    : posts.length,
            itemBuilder: (context, i) {
              if (i < posts.length) {
                return Post(post: posts[i]);
              }
              return const Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );
        }
        if (state.status == PostStatus.loading) {
          return const Center(
            child: SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return const Text("no posts found");
      },
    );
  }

  void _onScroll() {
    if (_isBottom) context.read<PostBloc>().add(PostsNextPage());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
}
