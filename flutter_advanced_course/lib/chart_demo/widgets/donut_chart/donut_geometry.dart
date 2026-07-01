import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/chart_demo/core/constants.dart';
import 'package:flutter_advanced_course/chart_demo/models/donut_slice_data.dart';

const double _kOuterCornerDepthRatio = 0.20;
const double _kInnerCornerDepthRatio = 0.218;
const double _kCurveStrengthMultiplier = 0.9;
const double _kTinySliceThresholdDeg = 12.0;
const double _kTinySliceGapMultiplier = 0.6;
const double _kTinyOuterCornerMul = 0.8;
const double _kTinyInnerCornerMul = 0.6;
const double _kOuterCornerAngleDeg = 5.0;
const double _kInnerCornerAngleDeg = 8.0;

const double _kStartAngle = -pi / 2;

class NormalizedSlice {
  NormalizedSlice({required this.original, required this.percentage});

  final DonutSliceData original;
  final double percentage;
}

class SliceGeometry {
  SliceGeometry({
    required this.index,
    required this.startAngle,
    required this.endAngle,
    required this.outerRadius,
    required this.innerRadius,
    required this.outerCornerAngle,
    required this.innerCornerAngle,
    required this.curveStrength,
    required this.donut,
  });

  final int index;
  final double startAngle;
  final double endAngle;
  final double outerRadius;
  final double innerRadius;
  final double outerCornerAngle;
  final double innerCornerAngle;
  final double curveStrength;
  final DonutGeometry donut;

  Path buildPath() => donut.buildSlicePath(index);
}

class DonutGeometry {
  DonutGeometry({
    required this.slices,
    required this.size,
    required this.strokeWidth,
    required this.sliceInset,
    required this.animationValues,
    required this.sweepProgress,
  }) {
    center = Offset(size.width / 2, size.height / 2);
    outerRadius = (size.width - strokeWidth) / 2 + strokeWidth / 2;
    innerRadius = outerRadius - strokeWidth;
    outerCornerDepth = (outerRadius - innerRadius) * _kOuterCornerDepthRatio;
    innerCornerDepth = (outerRadius - innerRadius) * _kInnerCornerDepthRatio;
  }

  final List<NormalizedSlice> slices;
  final Size size;
  final double strokeWidth;
  final double sliceInset;
  final Map<int, double> animationValues;
  final double sweepProgress;

  late Offset center;
  late double outerRadius;
  late double innerRadius;
  late double outerCornerDepth;
  late double innerCornerDepth;

  final List<SliceGeometry> sliceGeometries = [];

  void buildSlices() {
    sliceGeometries.clear();

    final totalPct = slices.fold(0.0, (sum, s) => sum + s.percentage);
    final gapRad = _toRad(DonutDefaults.gapDegrees);

    final hasTiny = slices.any((s) {
      final sweep = (s.percentage / totalPct) * 2 * pi - gapRad;

      return sweep < _toRad(_kTinySliceThresholdDeg);
    });

    final adjustedGap = hasTiny ? gapRad * _kTinySliceGapMultiplier : gapRad;
    final curveStrength = adjustedGap * _kCurveStrengthMultiplier;

    final maxTotalAngle = 2 * pi * sweepProgress;

    var angleConsumed = 0.0;

    var currentStart = _kStartAngle;

    for (var i = 0; i < slices.length; i++) {
      final slice = slices[i];
      final fullSweep = (slice.percentage / totalPct) * 2 * pi - adjustedGap;

      final angleRemaining = maxTotalAngle - angleConsumed;
      if (angleRemaining <= 0) break;

      final actualSweep = fullSweep.clamp(0.0, angleRemaining);
      angleConsumed += actualSweep + adjustedGap;

      final isTiny = actualSweep < _toRad(_kTinySliceThresholdDeg);

      var outerCornerAngle = _toRad(_kOuterCornerAngleDeg);
      var innerCornerAngle = _toRad(_kInnerCornerAngleDeg);

      if (isTiny) {
        outerCornerAngle *= _kTinyOuterCornerMul;
        innerCornerAngle *= _kTinyInnerCornerMul;
      }

      final expansion = animationValues[i] ?? 0.0;
      final inset = sliceInset * (1 - expansion);
      final animatedOuter = outerRadius - inset;
      final animatedInner = innerRadius - inset;

      sliceGeometries.add(
        SliceGeometry(
          donut: this,
          index: i,
          startAngle: currentStart,
          endAngle: currentStart + actualSweep,
          outerRadius: animatedOuter,
          innerRadius: animatedInner,
          outerCornerAngle: outerCornerAngle,
          innerCornerAngle: innerCornerAngle,
          curveStrength: curveStrength,
        ),
      );

      currentStart += actualSweep + adjustedGap;
    }
  }

  Path buildSlicePath(int index) {
    if (sliceGeometries.length == 1) return _buildFullRingPath(index);
    return _buildRoundedSlicePath(index);
  }

  Path _buildFullRingPath(int index) {
    final anim = animationValues[index] ?? 0.0;
    final inset = sliceInset * (1 - anim);

    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: outerRadius - inset))
      ..addOval(Rect.fromCircle(center: center, radius: innerRadius - inset))
      ..fillType = PathFillType.evenOdd;
  }

  Path _buildRoundedSlicePath(int index) {
    final s = sliceGeometries[index];

    final outerStartA = s.startAngle + s.outerCornerAngle;
    final outerEndA = s.endAngle - s.outerCornerAngle;
    final innerStartA = s.startAngle + s.innerCornerAngle;
    final innerEndA = s.endAngle - s.innerCornerAngle;

    final outerCornerStart = _pt(
      s.outerRadius - outerCornerDepth,
      s.startAngle,
    );

    final outerCornerEnd = _pt(s.outerRadius - outerCornerDepth, s.endAngle);

    final innerCornerStart = _pt(
      s.innerRadius + innerCornerDepth,
      s.startAngle,
    );

    final innerCornerEnd = _pt(s.innerRadius + innerCornerDepth, s.endAngle);

    final outerArcStart = _pt(s.outerRadius, outerStartA);

    final innerArcEnd = _pt(s.innerRadius, innerEndA);

    final path = Path()..moveTo(outerCornerStart.dx, outerCornerStart.dy);

    final outerCtrl1 = _ctrl(
      s.outerRadius,
      s.startAngle,
      s.curveStrength,
      true,
    );

    final outerCtrl2 = _ctrl(
      s.outerRadius,
      outerStartA,
      s.curveStrength,
      false,
    );

    path.cubicTo(
      outerCtrl1[0],
      outerCtrl1[1],
      outerCtrl2[0],
      outerCtrl2[1],
      outerArcStart.dx,
      outerArcStart.dy,
    );

    path.arcTo(
      Rect.fromCircle(center: center, radius: s.outerRadius),
      outerStartA,
      outerEndA - outerStartA,
      false,
    );

    final outerCtrl3 = _ctrl(s.outerRadius, outerEndA, s.curveStrength, true);

    final outerCtrl4 = _ctrl(s.outerRadius, s.endAngle, s.curveStrength, false);

    path.cubicTo(
      outerCtrl3[0],
      outerCtrl3[1],
      outerCtrl4[0],
      outerCtrl4[1],
      outerCornerEnd.dx,
      outerCornerEnd.dy,
    );

    path.lineTo(innerCornerEnd.dx, innerCornerEnd.dy);

    final innerCtrl1 = _ctrl(s.innerRadius, s.endAngle, s.curveStrength, false);
    final innerCtrl2 = _ctrl(s.innerRadius, innerEndA, s.curveStrength, true);

    path.cubicTo(
      innerCtrl1[0],
      innerCtrl1[1],
      innerCtrl2[0],
      innerCtrl2[1],
      innerArcEnd.dx,
      innerArcEnd.dy,
    );

    path.arcTo(
      Rect.fromCircle(center: center, radius: s.innerRadius),
      innerEndA,
      -(innerEndA - innerStartA),
      false,
    );

    final innerCtrl3 = _ctrl(
      s.innerRadius,
      innerStartA,
      s.curveStrength,
      false,
    );
    final innerCtrl4 = _ctrl(
      s.innerRadius,
      s.startAngle,
      s.curveStrength,
      true,
    );
    path.cubicTo(
      innerCtrl3[0],
      innerCtrl3[1],
      innerCtrl4[0],
      innerCtrl4[1],
      innerCornerStart.dx,
      innerCornerStart.dy,
    );

    path
      ..lineTo(outerCornerStart.dx, outerCornerStart.dy)
      ..close();

    return path;
  }

  Offset _pt(double radius, double angle) =>
      Offset(center.dx + radius * cos(angle), center.dy + radius * sin(angle));

  List<double> _ctrl(double radius, double angle, double dist, bool cw) {
    final p = _pt(radius, angle);
    final dx = cos(angle);
    final dy = sin(angle);
    final tx = cw ? -dy : dy;
    final ty = cw ? dx : -dx;
    return [p.dx + tx * dist, p.dy + ty * dist];
  }

  static double _toRad(double deg) => deg * pi / 180.0;
}

class DonutNormalizer {
  static List<NormalizedSlice> normalize(
    List<DonutSliceData> slices, {
    double minSlicePct = DonutDefaults.minSlicePct,
  }) {
    if (slices.isEmpty) return [];

    final total = slices.fold(0.0, (sum, s) => sum + s.value);
    if (total == 0) {
      final pct = 100.0 / slices.length;
      return slices
          .map((s) => NormalizedSlice(original: s, percentage: pct))
          .toList();
    }

    final normalized = slices
        .map(
          (s) =>
              NormalizedSlice(original: s, percentage: s.value / total * 100),
        )
        .toList();

    final smallIdxs = <int>[];
    final largeIdxs = <int>[];
    for (var i = 0; i < normalized.length; i++) {
      if (normalized[i].percentage < minSlicePct) {
        smallIdxs.add(i);
      } else {
        largeIdxs.add(i);
      }
    }

    if (smallIdxs.isEmpty) return normalized;

    var totalDeficit = 0.0;
    for (final i in smallIdxs) {
      totalDeficit += minSlicePct - normalized[i].percentage;
      normalized[i] = NormalizedSlice(
        original: normalized[i].original,
        percentage: minSlicePct,
      );
    }

    if (largeIdxs.isEmpty) return normalized;
    final largeTotal = largeIdxs.fold(
      0.0,
      (sum, i) => sum + normalized[i].percentage,
    );
    for (final i in largeIdxs) {
      final reduction = totalDeficit * (normalized[i].percentage / largeTotal);
      normalized[i] = NormalizedSlice(
        original: normalized[i].original,
        percentage: normalized[i].percentage - reduction,
      );
    }

    return normalized;
  }
}
