import 'package:flutter/material.dart';

enum DeviceType {
  mobile(0),
  tablet(600),
  desktop(950);

  final double minWidth;

  const DeviceType(this.minWidth);

  static DeviceType getDeviceType(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    if (width >= DeviceType.desktop.minWidth) return DeviceType.desktop;
    if (width >= DeviceType.tablet.minWidth) return DeviceType.tablet;
    return DeviceType.mobile;
  }
}
