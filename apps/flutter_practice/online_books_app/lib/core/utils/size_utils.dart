import 'package:flutter/material.dart';

// Define constants for the Figma design dimensions
const num FIGMA_DESIGN_WIDTH = 430;

const num FIGMA_DESIGN_HEIGHT = 932;

extension ResponsiveExtension on num {
  double get w {
    return (this * SizeUtils.width) / FIGMA_DESIGN_WIDTH;
  }

  double get h {
    return (this * SizeUtils.height) / FIGMA_DESIGN_HEIGHT;
  }

  double get v {
    return (this * SizeUtils.height) / FIGMA_DESIGN_HEIGHT;
  }

  double get fSize {
    double baseFontSize = (this * (SizeUtils.width / FIGMA_DESIGN_WIDTH));
    if (SizeUtils.deviceType == DeviceType.tablet) {
      return baseFontSize * 1.15;
    } else if (SizeUtils.deviceType == DeviceType.desktop) {
      return baseFontSize * 1.4;
    }
    return baseFontSize;
  }
}

extension FormatExtension on double {
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }

  double isNonZero({num defaultValue = 0.0}) {
    return this > 0 ? this : defaultValue.toDouble();
  }
}

enum DeviceType { mobile, tablet, desktop }

typedef ResponsiveBuild = Widget Function(
  BuildContext context,
  Orientation orientation,
  DeviceType deviceType,
);

class Sizer extends StatelessWidget {
  const Sizer({super.key, required this.builder});

  final ResponsiveBuild builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SizeUtils.setScreenSize(context);
        return builder(context, SizeUtils.orientation, SizeUtils.deviceType);
      },
    );
  }
}

class SizeUtils {
  static double width = 0;
  static double height = 0;

  static late DeviceType deviceType;

  static late Orientation orientation;

  static void setScreenSize(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    width = mediaQuery.size.width;
    height = mediaQuery.size.height;
    orientation = mediaQuery.orientation;
    textScaleFactor = mediaQuery.textScaler;

    // Dynamically determine device type based on screen width
    if (width >= 1024) {
      deviceType = DeviceType.desktop; // Desktop breakpoint
    } else if (width >= 600) {
      deviceType = DeviceType.tablet; // Tablet breakpoint
    } else {
      deviceType = DeviceType.mobile; // Mobile breakpoint
    }
  }

  // Utility to determine if screen is smaller than maxWidth
  static bool isSmallScreen(double maxWidth) => width < maxWidth;
  static TextScaler textScaleFactor = const TextScaler.linear(1.0);
}
