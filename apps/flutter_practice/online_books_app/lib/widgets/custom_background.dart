import 'package:flutter/material.dart';
import 'package:online_books_app/core/theme/theme_helper.dart';

class CustomBackgroundWidget extends StatelessWidget {
  final Widget child;
  final String backgroundImage;

  const CustomBackgroundWidget({
    super.key,
    required this.child,
    this.backgroundImage = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ClipPath(
            clipper: CurvedClipper(),
            child: Container(
              height: 250,
              color: appTheme.yellow700,
            ),
          ),
          Positioned(
            top: 250,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 40);
    path.cubicTo(size.width / 4, size.height - 100, size.width * 3 / 4,
        size.height - 100, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
