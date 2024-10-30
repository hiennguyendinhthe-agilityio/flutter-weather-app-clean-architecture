import 'package:bazar_books_app/example/example_cached_query/post_list_page.dart';
import 'package:bazar_books_app/example/example_cached_query/post_with_builder_page.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        PostListPage.routeName: (_) => const PostListPage(),
        PostListWithBuilderPage.routeName: (_) =>
            const PostListWithBuilderPage(),
      },
    );
  }
}
