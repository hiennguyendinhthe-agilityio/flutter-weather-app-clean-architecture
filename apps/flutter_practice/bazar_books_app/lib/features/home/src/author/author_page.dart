import 'package:bazar_books_app/features/home/src/author/author_inner_page.dart';
import 'package:bazar_books_app/features/home/src/author/models/author_inner_model.dart';
import 'package:bazar_books_design/widgets/list_title/listtile.dart';
import 'package:flutter/material.dart';

class AuthorsPage extends StatelessWidget {
  const AuthorsPage({
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
