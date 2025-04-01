import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/utils/image_constant.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/presentation/audio_books/controller/audio_book_controller.dart';
import 'package:online_books_app/presentation/audio_books/controller/audio_controller.dart';
import 'package:online_books_app/presentation/audio_books/widgets/audio_controlls.dart';
import 'package:online_books_app/theme/app_decoration.dart';
import 'package:online_books_app/theme/theme_helper.dart';
import 'package:online_books_app/widgets/app_bar/appbar_leading_image.dart';

class AudioPlayerScreen extends StatelessWidget {
  final String title;
  final String audioUrl;

  const AudioPlayerScreen({
    super.key,
    required this.title,
    required this.audioUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize the audio controller
    final AudioController audioController = Get.put(
      AudioController(audioUrl: audioUrl),
    );
    final AudioBookController controller = Get.find<AudioBookController>();

    return Scaffold(
      backgroundColor: controller.backgroundColor.value,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(title),
        centerTitle: true,
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
      body: Column(
        children: [
          // Main content area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Obx(
                () => Container(
                  height: double.maxFinite,
                  color: controller.backgroundColor.value,
                  padding: const EdgeInsets.all(16.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '"matters of consequence!"',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'he looked at me there with my hammer in my hand, my fingers black with engine-grease, bending down over an object which seemed to him extremely ugly...',
                      ),
                      SizedBox(height: 8),
                      Text('"you talk just like the grown-ups!"'),
                      SizedBox(height: 8),
                      Text(
                          'that made me a little ashamed. but we went on, relentlessly:'),
                      SizedBox(height: 8),
                      Text(
                          '"you mix everything up together... you confuse everything..."'),
                      SizedBox(height: 8),
                      Text(
                          'he was really angry. he tossed his golden curls in the breeze.'),
                      SizedBox(height: 8),
                      Text(
                          '"i know a planet where there is a certain red-faced gentleman. he has never smelled a flower. he has never looked at a star. he has never loved any one. he has never done anything in his life but add up figures. and all day he says over and over, just like you: "i am busy with matters of consequence!" and that\'s make him swell up with pride. but he is not a man he is a mushroom!"'),
                      SizedBox(height: 8),
                      Text('"what?"'),
                      SizedBox(height: 8),
                      Text('"a mushroom!"'),
                      SizedBox(height: 8),
                      Text('the little prince was now white with rage.'),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Audio controls at the bottom
          AudioControls(audioController: audioController),
        ],
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
                              if (Get.find<AudioBookController>()
                                      .textSize
                                      .value >
                                  10) {
                                Get.find<AudioBookController>()
                                    .textSize
                                    .value--;
                              }
                            },
                          ),
                          Text(
                              '${Get.find<AudioBookController>().textSize.value.toInt()}%'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if (Get.find<AudioBookController>()
                                      .textSize
                                      .value <
                                  30) {
                                Get.find<AudioBookController>()
                                    .textSize
                                    .value++;
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
                              if (Get.find<AudioBookController>()
                                      .lineHeight
                                      .value >
                                  1.0) {
                                Get.find<AudioBookController>()
                                    .lineHeight
                                    .value -= 0.1;
                              }
                            },
                          ),
                          Text(
                              '${(Get.find<AudioBookController>().lineHeight.value * 100).toInt()}%'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if (Get.find<AudioBookController>()
                                      .lineHeight
                                      .value <
                                  2.0) {
                                Get.find<AudioBookController>()
                                    .lineHeight
                                    .value += 0.1;
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
      onPressed: () =>
          Get.find<AudioBookController>().backgroundColor.value = color,
    );
  }
}
