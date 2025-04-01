import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/utils/image_constant.dart';
import 'package:online_books_app/presentation/audio_books/audio_books_detail_screen.dart';
import 'package:online_books_app/presentation/audio_books/controller/audio_book_controller.dart';
import 'package:online_books_app/presentation/audio_books/controller/author_audio_controller.dart';
import 'package:online_books_app/presentation/audio_books/model/audio_books_model.dart';
import 'package:online_books_app/presentation/audio_books/widgets/network_audio_book.dart';
import 'package:online_books_app/theme/theme_helper.dart';

class ListAudioBooksScreen extends StatelessWidget {
  const ListAudioBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'List AudioBook',
          style: theme.textTheme.titleLarge,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildAudioBooksGrid(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAudioBooksGrid(BuildContext context) {
    final AudioBookController controller = Get.put(AudioBookController());
    final AuthorAudioController audioAuthorController =
        Get.put(AuthorAudioController());
    audioAuthorController.fetchBooks();

    return Obx(() {
      if (audioAuthorController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (audioAuthorController.authors.isEmpty) {
        return Center(child: Text('No authors found'));
      }

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.85,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: audioAuthorController.authors.length,
        itemBuilder: (context, index) {
          AudioBooks audioBook = audioAuthorController.authors[index];
          return GestureDetector(
            onTap: () {
              controller.setAudioBookData(
                title: audioBook.fullName ?? 'Unknown',
                description: audioBook.biography ?? 'No biography available',
                author: audioBook.fullName ?? 'Unknown',
                imagePath: audioBook.avatarUrl ?? '',
                starRating: audioBook.starRating ?? 0,
                duration: audioBook.duration ?? 'Unknown',
              );

              Get.to(() => AudioBooksDetailScreen(), arguments: audioBook);
            },
            child: NetworkAudioBookCard(
              title: audioBook.fullName ?? 'Unknown',
              duration: audioBook.duration ?? 'Unknown',
              imageUrl: audioBook.avatarUrl ?? ImageConstant.imgRectangle119,
            ),
          );
        },
      );
    });
  }
}
