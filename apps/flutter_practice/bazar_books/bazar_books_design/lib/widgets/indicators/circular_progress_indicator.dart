import 'package:flutter/material.dart';

class BazUiCircularProgressIndicator extends StatelessWidget {
  const BazUiCircularProgressIndicator({
    this.backgroundColor,
    this.width,
    this.height,
    super.key,
  });

  final Color? backgroundColor;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 19,
      width: 19,
      child: CircularProgressIndicator.adaptive(
        backgroundColor: backgroundColor,
      ),
    );
  }
}
