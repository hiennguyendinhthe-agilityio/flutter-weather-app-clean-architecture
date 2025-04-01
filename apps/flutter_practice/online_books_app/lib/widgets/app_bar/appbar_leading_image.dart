import 'package:flutter/material.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/widgets/custom_image_view.dart';

class AppbarLeadingImage extends StatelessWidget {
  const AppbarLeadingImage(
      {super.key,
      this.imagePath,
      this.height,
      this.width,
      this.onTap,
      this.margin});

  final String? imagePath;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
          onTap: onTap,
          child: CustomImageView(
            imagePath: imagePath!,
            height: height ?? 24.h,
            width: width ?? 24.h,
            fit: BoxFit.contain,
          )),
    );
  }
}
