import 'dart:math';

import 'package:flutter/material.dart';

mixin RingInteractionMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  late AnimationController sweepController;
  late Animation<double> sweepAnimation;
  late List<AnimationController> focusControllers;
  int? selectedIndex;

  void initRingAnimations({
    required int ringCount,
    Duration sweepDuration = const Duration(milliseconds: 1400),
    Duration focusDuration = const Duration(milliseconds: 400),
  }) {
    sweepController = AnimationController(vsync: this, duration: sweepDuration);
    sweepAnimation = CurvedAnimation(
      parent: sweepController,
      curve: Curves.easeOutCubic,
    );
    focusControllers = List.generate(
      ringCount,
      (_) =>
          AnimationController(vsync: this, duration: focusDuration, value: 1.0),
    );
    sweepController.forward();
  }

  void disposeRingAnimations() {
    sweepController.dispose();
    for (var controller in focusControllers) {
      controller.dispose();
    }
  }

  void onLegendTapped(int index) {
    setState(() {
      if (selectedIndex == index) {
        selectedIndex = null;
        for (var controller in focusControllers) {
          controller.animateTo(1.0, curve: Curves.easeOutCubic);
        }
      } else {
        selectedIndex = index;
        for (int i = 0; i < focusControllers.length; i++) {
          if (i == index) {
            focusControllers[i].value = 0.4;
            focusControllers[i].animateTo(1.0, curve: Curves.easeOutBack);
          } else {
            focusControllers[i].animateTo(0.0, curve: Curves.easeOutCubic);
          }
        }
      }
    });
  }

  int? getHitIndex(
    Offset position,
    double size,
    double spacing,
    List<double> strokeWidths,
  ) {
    final center = Offset(size / 2, size / 2);
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;
    final distance = sqrt(dx * dx + dy * dy);

    final maxRadius = size / 2;
    int? hitIndex;

    final List<double> radii = [];
    double currentOuter = maxRadius;

    for (int i = strokeWidths.length - 1; i >= 0; i--) {
      final sw = strokeWidths[i];
      final radius = currentOuter - (sw / 2);
      radii.insert(0, radius);
      currentOuter = radius - (sw / 2) - spacing;
    }

    for (int i = 0; i < strokeWidths.length; i++) {
      final sw = strokeWidths[i];
      final radius = radii[i];

      final outerBound = radius + (sw / 2) + (spacing / 2);
      final innerBound = radius - (sw / 2) - (spacing / 2);

      if (distance >= innerBound && distance <= outerBound) {
        hitIndex = i;
        break;
      }
    }

    return hitIndex;
  }

  void handleCanvasTapped(
    Offset position,
    double size,
    double spacing,
    List<double> strokeWidths,
  ) {
    final hitIndex = getHitIndex(position, size, spacing, strokeWidths);
    if (hitIndex != null) {
      onLegendTapped(hitIndex);
    } else if (selectedIndex != null) {
      setState(() {
        selectedIndex = null;
        for (var controller in focusControllers) {
          controller.animateTo(1.0, curve: Curves.easeOutCubic);
        }
      });
    }
  }
}
