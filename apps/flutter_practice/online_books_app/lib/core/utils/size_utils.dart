import 'package:flutter/material.dart';

// Define constants for the Figma design dimensions
const num FIGMA_DESIGN_WIDTH = 430;
const num FIGMA_DESIGN_WIDTH_AND_HEIGHT =
    830; // New value that combines both width and height
const num FIGMA_DESIGN_HEIGHT = 932;

extension ResponsiveExtension on num {
  double get w {
    // Use the FIGMA_DESIGN_WIDTH_AND_HEIGHT when both width and height are considered
    if (SizeUtils.width >= FIGMA_DESIGN_WIDTH_AND_HEIGHT) {
      return (this * SizeUtils.width) / FIGMA_DESIGN_WIDTH_AND_HEIGHT;
    }
    return (this * SizeUtils.width) / FIGMA_DESIGN_WIDTH;
  }

  double get h {
    // Use the FIGMA_DESIGN_WIDTH_AND_HEIGHT when both width and height are considered
    if (SizeUtils.height >= FIGMA_DESIGN_WIDTH_AND_HEIGHT) {
      return (this * SizeUtils.height) / FIGMA_DESIGN_WIDTH_AND_HEIGHT;
    }
    return (this * SizeUtils.height) / FIGMA_DESIGN_HEIGHT;
  }

  double get fSize {
    // Base font size scaling based on width
    double baseFontSize = (this * (SizeUtils.width / FIGMA_DESIGN_WIDTH));

    // Apply different multipliers based on device type
    if (SizeUtils.deviceType == DeviceType.tablet) {
      return baseFontSize * 1.15;
    } else if (SizeUtils.deviceType == DeviceType.desktop) {
      return baseFontSize * 1.4;
    }

    return baseFontSize; // Default for mobile
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
}
