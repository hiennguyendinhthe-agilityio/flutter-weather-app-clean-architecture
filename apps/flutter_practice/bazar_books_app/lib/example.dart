import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure CachedQuery for Flutter
  CachedQuery.instance.configFlutter(
    config: QueryConfigFlutter(
      refetchOnResume: true,
      refetchOnConnection: true,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Cached Query Flutter Demo',
      home: PostPage(),
    );
  }
}

class PostModel {
  final String title;
  final int id;
  final String body;

  PostModel({required this.title, required this.id, required this.body});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      title: json['title'],
      id: json['id'],
      body: json['body'],
    );
  }
}

// Function to create a query for fetching posts
Query<PostModel> getPostById(int id) {
  return Query<PostModel>(
    key: 'post_$id',
    queryFn: () async {
      final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/$id');
      final response = await Dio().get(uri.toString());
      debugPrint('$response');
      final Map<String, dynamic> result = response.data;
      return PostModel.fromJson(result);
    },
  );
}

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  int currentId = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: QueryBuilder<PostModel>(
          query: getPostById(currentId),
          builder: (context, state) {
            return Text(state.status == QueryStatus.loading
                ? 'Loading...'
                : state.data?.title ?? 'Post');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                CachedQuery.instance.getQuery('post_$currentId')?.refetch(),
          ),
        ],
      ),
      body: Center(
        child: QueryBuilder<PostModel>(
          query: getPostById(currentId),
          builder: (context, state) {
            if (state.status == QueryStatus.error) {
              return Text('Error: ${state.error}');
            } else if (state.status == QueryStatus.loading) {
              return const CircularProgressIndicator();
            } else if (state.data != null) {
              return Column(
                children: [
                  Text('Post ID: ${state.data!.id}'),
                  Text(state.data!.body),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_left),
                        onPressed: () => setState(() => currentId =
                            currentId > 1 ? currentId - 1 : currentId),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_right),
                        onPressed: () => setState(() => currentId += 1),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
