import 'package:flutter/material.dart';

class CommonGradientBackground extends StatelessWidget {
  const CommonGradientBackground({
    super.key,
    required this.child,
    this.padding,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: padding,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 95, 219, 250),
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.center,
          stops: [0.3, 1.0],
        ),
      ),
      child: child,
    );
  }
}
