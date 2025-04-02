import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/theme/custom_text_style.dart';
import 'package:online_books_app/core/utils/image_constant.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/presentation/audio_books/audio_books_detail_screen.dart';
import 'package:online_books_app/presentation/audio_books/controller/audio_book_controller.dart';
import 'package:online_books_app/presentation/audio_books/model/audio_books_model.dart';
import 'package:online_books_app/presentation/audio_books/widgets/network_audio_book.dart';
import 'package:online_books_app/presentation/e_books/ebook_detail_screen.dart';
import 'package:online_books_app/presentation/e_books/models/books_model.dart';
import 'package:online_books_app/presentation/e_books/read_books_screen.dart';
import 'package:online_books_app/presentation/e_books/widgets/item_list_ebooks_widget.dart';
import 'package:online_books_app/presentation/saved/controller/saved_controller.dart';

class SavedScreen extends StatelessWidget {
  SavedScreen({super.key});

  final SavedBooksController savedBooksController =
      Get.find<SavedBooksController>();
  final SavedAudioBooksController savedAudioBooksController =
      Get.find<SavedAudioBooksController>();
  final AudioBookController controller = Get.put(AudioBookController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "lbl_saved".tr,
          style: CustomTextStyles.titleLargeDosisBluegray900,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Obx(() {
          if (savedBooksController.savedBooks.isEmpty &&
              savedAudioBooksController.savedAudioBooks.isEmpty) {
            return Center(child: Text("No books or audio books saved"));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (savedBooksController.savedBooks.isNotEmpty) ...[
                  _buildBookRow(),
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: savedBooksController.savedBooks.length,
                    itemBuilder: (context, index) {
                      Books book = savedBooksController.savedBooks[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => EBookDetailScreen(), arguments: book);
                        },
                        child: ItemListEbooksWidget(
                          onTap: () {
                            Get.to(() => ReadBookScreen(
                                  bookTitle: book.fullName ?? 'Unknown',
                                  bookContent:
                                      book.pdfUrl ?? 'No content available',
                                ));
                          },
                          title: book.fullName ?? 'Unknown',
                          author: book.fullName ?? 'Unknown',
                          imagePath: book.avatarUrl ?? '',
                          category: book.occupation ?? 'Unknown',
                          description:
                              book.biography ?? 'No biography available',
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 16.h),
                  ),
                ],
                if (savedAudioBooksController.savedAudioBooks.isNotEmpty) ...[
                  _buildAudioBooksRow(),
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: savedAudioBooksController.savedAudioBooks.length,
                    itemBuilder: (context, index) {
                      AudioBooks audioBook =
                          savedAudioBooksController.savedAudioBooks[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => AudioBooksDetailScreen(),
                              arguments: audioBook);
                        },
                        child: NetworkAudioBookCard(
                          title: audioBook.fullName ?? 'Unknown',
                          duration: audioBook.duration ?? 'Unknown',
                          imageUrl: audioBook.avatarUrl ??
                              ImageConstant.imgRectangle119,
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBookRow() {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Books",
            style: CustomTextStyles.titleLargeConcertOneBlack900Regular_1,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Text(
                "See more",
                style: CustomTextStyles.bodyMediumBlack900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioBooksRow() {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Audio Books",
              style: CustomTextStyles.titleLargeConcertOneBlack900Regular_1),
          Text("See more", style: CustomTextStyles.bodyMediumBlack900),
        ],
      ),
    );
  }
}
