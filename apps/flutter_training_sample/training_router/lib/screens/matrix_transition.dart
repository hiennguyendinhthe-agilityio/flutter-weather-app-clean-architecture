import 'dart:math';

import 'package:flutter/material.dart';

class MatrixTransitionPageRoute extends PageRouteBuilder {
  final Widget page;

  MatrixTransitionPageRoute({
    required this.page,
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return page;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                final double value = animation.value;
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(value * pi * 2), // Rotate 360 degrees
                  alignment: Alignment.center,
                  child: child,
                );
              },
              child: child,
            );
          },
        );
}
