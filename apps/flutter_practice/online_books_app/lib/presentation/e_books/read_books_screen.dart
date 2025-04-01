import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/utils/image_constant.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/presentation/e_books/controller/book_controller.dart';
import 'package:online_books_app/theme/app_decoration.dart';
import 'package:online_books_app/theme/theme_helper.dart';
import 'package:online_books_app/widgets/app_bar/appbar_leading_image.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReadBookScreen extends StatelessWidget {
  final String bookTitle;
  final String bookContent;

  const ReadBookScreen(
      {super.key, required this.bookTitle, required this.bookContent});

  @override
  Widget build(BuildContext context) {
    final BookController controller = Get.find<BookController>();

    return Scaffold(
      backgroundColor: controller.backgroundColor.value,
      appBar: AppBar(
        leadingWidth: 40.h,
        centerTitle: true,
        title: Text(bookTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: AppbarLeadingImage(
              imagePath: ImageConstant.sort,
              onTap: () => _showBottomSheet(context),
            ),
          ),
        ],
      ),
      body: SfPdfViewer.network(
        bookContent,
        onDocumentLoadFailed: (details) {
          Get.snackbar(
            'Error',
            'Failed to load PDF: ${details.error}',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    Get.bottomSheet(
      backgroundColor: Colors.white,
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header cho BottomSheet
            Align(
              alignment: Alignment.center,
              child: Text(
                'Text Size and Color',
                style: theme.textTheme.headlineSmall,
              ),
            ),
            SizedBox(height: 16),
            // Text Size và Line Height
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Text Size",
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      decoration: AppDecoration.outlineGray.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder12,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (Get.find<BookController>().textSize.value >
                                  10) {
                                Get.find<BookController>().textSize.value--;
                              }
                            },
                          ),
                          Text(
                              '${Get.find<BookController>().textSize.value.toInt()}%'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if (Get.find<BookController>().textSize.value <
                                  30) {
                                Get.find<BookController>().textSize.value++;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Line Height"),
                    SizedBox(height: 12.h),
                    Container(
                      decoration: AppDecoration.outlineGray.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder12,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (Get.find<BookController>().lineHeight.value >
                                  1.0) {
                                Get.find<BookController>().lineHeight.value -=
                                    0.1;
                              }
                            },
                          ),
                          Text(
                              '${(Get.find<BookController>().lineHeight.value * 100).toInt()}%'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if (Get.find<BookController>().lineHeight.value <
                                  2.0) {
                                Get.find<BookController>().lineHeight.value +=
                                    0.1;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            // Background Color và Highlight Color
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Background Color"),
                      Row(
                        children: [
                          _buildColorIconButton(Colors.black),
                          _buildColorIconButton(Colors.white),
                          _buildColorIconButton(Colors.grey),
                          _buildColorIconButton(Colors.yellow),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorIconButton(Color color) {
    return IconButton(
      icon: Icon(Icons.circle, color: color),
      onPressed: () => Get.find<BookController>().backgroundColor.value = color,
    );
  }
}
