import 'package:flutter/material.dart';
import 'package:online_books_app/core/app_export.dart';
import 'package:online_books_app/presentation/e_books/controller/author_controller.dart';
import 'package:online_books_app/presentation/e_books/controller/book_controller.dart';
import 'package:online_books_app/presentation/e_books/ebook_detail_screen.dart';
import 'package:online_books_app/presentation/e_books/models/books_model.dart';
import 'package:online_books_app/presentation/e_books/read_books_screen.dart';
import 'package:online_books_app/presentation/e_books/widgets/item_list_ebooks_widget.dart';

class ListEbooksScreen extends StatelessWidget {
  const ListEbooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BookController controller = Get.put(BookController());
    final AuthorBooksController authorController =
        Get.put(AuthorBooksController());

    if (authorController.authors.isEmpty) {
      authorController.fetchBooks();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'List Books',
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Obx(
          () {
            if (authorController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (authorController.authors.isEmpty) {
              return Center(child: Text('No authors found'));
            }

            return ListView.separated(
              itemCount: authorController.authors.length,
              itemBuilder: (context, index) {
                Books book = authorController.authors[index];
                return GestureDetector(
                  onTap: () {
                    controller.setBookData(
                      title: book.fullName ?? 'Unknown',
                      description: book.biography ?? 'No biography available',
                      author: book.fullName ?? 'Unknown',
                      imagePath:
                          book.avatarUrl ?? ImageConstant.imgRectangle159,
                      starRating: book.starRating ?? 0,
                      pdfUrl: book.pdfUrl ?? '',
                    );

                    Get.to(() => EBookDetailScreen(), arguments: book);
                  },
                  child: ItemListEbooksWidget(
                    onTap: () {
                      Get.to(() => ReadBookScreen(
                            bookTitle: book.fullName ?? 'Unknown',
                            bookContent: book.pdfUrl ?? 'No content available',
                          ));
                    },
                    imagePath: book.avatarUrl ?? ImageConstant.imgRectangle159,
                    title: book.fullName ?? 'Unknown',
                    author: book.fullName ?? 'Unknown',
                    category: book.occupation ?? 'Unknown',
                    description: book.biography ?? 'No biography available',
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
            );
          },
        ),
      ),
    );
  }
}
