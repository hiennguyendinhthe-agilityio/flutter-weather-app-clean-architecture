import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/chart_demo/core/constants.dart';
import 'package:flutter_advanced_course/chart_demo/models/bar_item_data.dart';
import 'package:flutter_advanced_course/chart_demo/widgets/bar_chart/bar_column.dart';

class BarChart extends StatelessWidget {
  const BarChart({
    super.key,
    required this.items,
    this.maxHeight = BarDefaults.maxHeight,
    this.columnWidth = BarDefaults.columnWidth,
    this.columnSpacing = BarDefaults.columnSpacing,
    this.borderRadius = BarDefaults.borderRadius,
    this.showLabels = true,
    this.labelStyle,
    this.entryDuration = AppDurations.entryAnimation,
    this.staggerDelay = AppDurations.staggerDelay,
    this.entryCurve = AppCurves.entry,
  });

  final List<BarItemData> items;
  final double maxHeight;
  final double columnWidth;
  final double columnSpacing;
  final double borderRadius;
  final bool showLabels;
  final TextStyle? labelStyle;
  final Duration entryDuration;
  final Duration staggerDelay;
  final Curve entryCurve;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: items.indexed.map((record) {
        final (index, item) = record;
        return Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? 0 : columnSpacing / 2,
            right: index == items.length - 1 ? 0 : columnSpacing / 2,
          ),
          child: BarColumn(
            item: item,
            maxHeight: maxHeight,
            columnWidth: columnWidth,
            borderRadius: borderRadius,
            showLabel: showLabels,
            labelStyle: labelStyle,
            entryDuration: entryDuration,
            entryCurve: entryCurve,

            entryDelay: staggerDelay * index,
          ),
        );
      }).toList(),
    );
  }
}
