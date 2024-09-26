import 'package:bazar_books_app/features/home/widgets/author/author_inner_page.dart';
import 'package:bazar_books_app/features/home/widgets/author/models/author_inner_model.dart';
import 'package:bazar_books_design/widgets/list_title/listtile.dart';
import 'package:flutter/material.dart';

class Authors extends StatelessWidget {
  const Authors({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authors'),
      ),
      body: ListView.builder(
        itemCount: authors.length,
        itemBuilder: (context, index) {
          final author = authors[index];
          return BazUiListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthorInnerPage(),
                ),
              );
            },
            leading: author['imageUrl']!,
            title: author['name']!,
            subtitle: author['description']!,
          );
        },
      ),
    );
  }
}
