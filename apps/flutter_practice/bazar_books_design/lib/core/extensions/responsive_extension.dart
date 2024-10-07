import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  bool get isTablet {
    return MediaQuery.of(this).size.width > 600;
  }

  double responsiveValue({required double mobile, required double tablet}) {
    return isTablet ? tablet : mobile;
  }

  int responsiveValueInt({required int mobile, required int tablet}) {
    return isTablet ? tablet : mobile;
  }

  double getFontSize({double mobile = 14, double tablet = 18}) {
    return responsiveValue(mobile: mobile, tablet: tablet);
  }

  double getWidgetSize({double mobile = 100, double tablet = 150}) {
    return responsiveValue(mobile: mobile, tablet: tablet);
  }

  int getWidgetSizeInt({int mobile = 100, int tablet = 150}) {
    return responsiveValueInt(mobile: mobile, tablet: tablet);
  }

  double getPadding({double mobile = 8, double tablet = 16}) {
    return responsiveValue(mobile: mobile, tablet: tablet);
  }

  double getButtonSpacing({double mobile = 16, double tablet = 24}) {
    return responsiveValue(mobile: mobile, tablet: tablet);
  }

  double getImageHeight({double mobile = 80, double tablet = 100}) {
    return responsiveValue(mobile: mobile, tablet: tablet);
  }

  double responsiveHeight({double mobile = 180, double tablet = 550}) {
    return isTablet ? tablet : mobile;
  }

  int getGridCrossAxisCount({int mobile = 1, int tablet = 3}) {
    return isTablet ? tablet : mobile;
  }

  double getCrossAxisSpacing({double mobile = 8, double tablet = 1}) {
    return isTablet ? tablet : mobile;
  }

  double getMainAxisSpacing({double mobile = 8, double tablet = 16}) {
    return isTablet ? tablet : mobile;
  }

  double getAspectRatio({double mobile = 1 / 1.5, double tablet = 1 / 1.02}) {
    return isTablet ? tablet : mobile;
  }

  double getAvatarRadius({double mobile = 30, double tablet = 40}) {
    return responsiveValue(mobile: mobile, tablet: tablet);
  }

  double getSubtitleFontSize({double mobile = 14, double tablet = 20}) {
    return responsiveValue(mobile: mobile, tablet: tablet);
  }
}
