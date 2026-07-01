import 'package:flutter/material.dart';

abstract class AppDurations {
  static const entryAnimation = Duration(milliseconds: 900);
  static const staggerDelay = Duration(milliseconds: 120);
  static const toggleAnimation = Duration(milliseconds: 300);
  static const dataUpdate = Duration(milliseconds: 600);
}

abstract class AppCurves {
  static const entry = Curves.easeOutCubic;
  static const toggle = Curves.easeInOut;
  static const update = Curves.easeInOutCubic;
  static const elastic = Curves.elasticOut;
}

abstract class DonutDefaults {
  static const dimension = 260.0;
  static const strokeRatio = 0.38;
  static const sliceInsetRatio = 0.055;
  static const gapDegrees = 3.5;
  static const minSlicePct = 3.28;
}

abstract class BarDefaults {
  static const columnWidth = 36.0;
  static const columnSpacing = 16.0;
  static const maxHeight = 200.0;
  static const borderRadius = 8.0;
  static const gapBetweenSegs = 2.0;
}
