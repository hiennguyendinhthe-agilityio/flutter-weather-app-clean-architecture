import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/chart_demo/core/account_stats_theme.dart';
import 'package:flutter_advanced_course/chart_demo/models/statistic_data.dart';

// ─────────────────────────────────────────────────────────────
// LAYOUT CONSTANTS  (single source of truth for geometry)
// ─────────────────────────────────────────────────────────────

/// Each group slot width = slotWidth.
/// Bar width   = slotWidth * [_kBarFraction].
/// The Clicks bar is drawn behind the Followers bar with exact horizontal alignment.
const double _kGroupGap = 4.0; // visual gap between consecutive slots
const double _kBarFraction = 0.55; // bar width as fraction of slot width
const double _kPeekOffset =
    0.0; // no horizontal offset, bars match horizontally
const double _kCornerRadius = 3.0;
const double _kYLabelWidth = 28.0;
const double _kXAxisHeight = 26.0;
const double _kTopPadding = 6.0;

// ─────────────────────────────────────────────────────────────
// PUBLIC WIDGET
// ─────────────────────────────────────────────────────────────

class CustomAnimatedBarChart extends StatefulWidget {
  const CustomAnimatedBarChart({
    super.key,
    required this.data,
    this.maxYValue = 15,
    this.yDivisions = 3,
    this.animationDuration = const Duration(milliseconds: 1300),
  });

  final List<StatisticData> data;
  final double maxYValue;
  final int yDivisions;
  final Duration animationDuration;

  @override
  State<CustomAnimatedBarChart> createState() => _CustomAnimatedBarChartState();
}

class _CustomAnimatedBarChartState extends State<CustomAnimatedBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late List<Animation<double>> _followerAnims;
  late List<Animation<double>> _clickAnims;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _buildAnimations();
    _controller.forward();
  }

  void _buildAnimations() {
    final count = widget.data.length;

    // Each bar gets a staggered Interval so they grow left-to-right.
    // Followers and Clicks are staggered 60 ms apart for the 3-D feel.
    _followerAnims = List.generate(count, (i) {
      final start = (i / count) * 0.55;
      final end = (start + 0.45).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOutBack),
      );
    });

    _clickAnims = List.generate(count, (i) {
      final start = ((i / count) * 0.55 + 0.04).clamp(0.0, 1.0);
      final end = (start + 0.45).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOutBack),
      );
    });
  }

  @override
  void didUpdateWidget(CustomAnimatedBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _buildAnimations();
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) => _ChartLayout(
        data: widget.data,
        maxYValue: widget.maxYValue,
        yDivisions: widget.yDivisions,
        followerAnims: _followerAnims,
        clickAnims: _clickAnims,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// INTERNAL LAYOUT  (Stack of three layers)
// ─────────────────────────────────────────────────────────────

class _ChartLayout extends StatelessWidget {
  const _ChartLayout({
    required this.data,
    required this.maxYValue,
    required this.yDivisions,
    required this.followerAnims,
    required this.clickAnims,
  });

  final List<StatisticData> data;
  final double maxYValue;
  final int yDivisions;
  final List<Animation<double>> followerAnims;
  final List<Animation<double>> clickAnims;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final chartWidth = constraints.maxWidth - _kYLabelWidth;
        final chartHeight =
            constraints.maxHeight - _kXAxisHeight - _kTopPadding;

        return Stack(
          children: [
            // ── Layer 1: grid lines + Y labels
            Positioned(
              left: 0,
              top: _kTopPadding,
              right: 0,
              bottom: _kXAxisHeight,
              child: CustomPaint(
                painter: _GridPainter(
                  maxYValue: maxYValue,
                  yDivisions: yDivisions,
                  yLabelWidth: _kYLabelWidth,
                ),
              ),
            ),

            // ── Layer 2: grouped bars (3-D overlap effect)
            Positioned(
              left: _kYLabelWidth,
              top: _kTopPadding,
              width: chartWidth,
              height: chartHeight,
              child: CustomPaint(
                painter: _BarsPainter(
                  data: data,
                  maxYValue: maxYValue,
                  followerAnims: followerAnims,
                  clickAnims: clickAnims,
                ),
              ),
            ),

            // ── Layer 3: X-axis date labels
            Positioned(
              left: _kYLabelWidth,
              bottom: 0,
              width: chartWidth,
              height: _kXAxisHeight,
              child: _XAxisLabels(data: data),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// GRID PAINTER — faint horizontal lines + right-aligned Y labels
// ─────────────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  const _GridPainter({
    required this.maxYValue,
    required this.yDivisions,
    required this.yLabelWidth,
  });

  final double maxYValue;
  final int yDivisions;
  final double yLabelWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // Grid lines: very faint (≈ 8 % opacity) so they don't compete with bars.
    final gridPaint = Paint()
      ..color = AccountStatsTheme.gridLine.withValues(alpha: 0.08)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    final labelStyle = const TextStyle(
      fontSize: 10,
      color: AccountStatsTheme.axisLabel,
      fontFamily: 'SF Pro Display',
    );

    final step = maxYValue / yDivisions;
    for (var i = 0; i <= yDivisions; i++) {
      final yVal = step * i;
      final ratio = yVal / maxYValue;
      final y = size.height * (1 - ratio);

      canvas.drawLine(Offset(yLabelWidth, y), Offset(size.width, y), gridPaint);

      final span = TextSpan(text: yVal.toInt().toString(), style: labelStyle);
      final tp = TextPainter(text: span, textDirection: TextDirection.ltr)
        ..layout(maxWidth: yLabelWidth - 4);
      tp.paint(canvas, Offset(yLabelWidth - tp.width - 4, y - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) =>
      old.maxYValue != maxYValue ||
      old.yDivisions != yDivisions ||
      old.yLabelWidth != yLabelWidth;
}

// ─────────────────────────────────────────────────────────────
// BARS PAINTER — 3-D overlap grouped bars
//
//  Geometry per slot  (slotWidth = chartWidth / count):
//
//   ┌──────────────────── slotWidth ──────────────────────┐
//   │◄─── barWidth ───►│                                  │
//   │  [Followers]      │                                  │
//   │         ◄── barWidth ──►                            │
//   │        [Clicks] (peeks _kPeekOffset px to the right)│
//   └─────────────────────────────────────────────────────┘
//
//  Draw order: Clicks first (behind), Followers second (in front).
//  This produces the subtle 3-D "Followers overlapping Clicks" look.
// ─────────────────────────────────────────────────────────────

class _BarsPainter extends CustomPainter {
  const _BarsPainter({
    required this.data,
    required this.maxYValue,
    required this.followerAnims,
    required this.clickAnims,
  });

  final List<StatisticData> data;
  final double maxYValue;
  final List<Animation<double>> followerAnims;
  final List<Animation<double>> clickAnims;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final count = data.length;
    // Each slot gets an equal share; _kGroupGap creates breathing room.
    final slotWidth = (size.width - _kGroupGap * (count - 1)) / count;
    final barWidth = slotWidth * _kBarFraction;

    const cornerRadius = Radius.circular(_kCornerRadius);

    for (var i = 0; i < count; i++) {
      final item = data[i];
      final slotLeft = i * (slotWidth + _kGroupGap);

      final followerRatio =
          (item.followers / maxYValue).clamp(0.0, 1.0) *
          followerAnims[i].value.clamp(0.0, 1.0);
      final clickRatio =
          (item.clicks / maxYValue).clamp(0.0, 1.0) *
          clickAnims[i].value.clamp(0.0, 1.0);

      // ── 1. Draw Clicks bar FIRST (behind), peeking _kPeekOffset right.
      _drawBar(
        canvas,
        size,
        left: slotLeft + _kPeekOffset,
        width: barWidth,
        ratio: clickRatio,
        color: AccountStatsTheme.clicksBarColor,
        cornerRadius: cornerRadius,
      );

      // ── 2. Draw Followers bar ON TOP, covering the left portion of Clicks.
      _drawBar(
        canvas,
        size,
        left: slotLeft,
        width: barWidth,
        ratio: followerRatio,
        color: AccountStatsTheme.followersColor,
        cornerRadius: cornerRadius,
      );
    }
  }

  void _drawBar(
    Canvas canvas,
    Size size, {
    required double left,
    required double width,
    required double ratio,
    required Color color,
    required Radius cornerRadius,
  }) {
    final barHeight = size.height * ratio;
    if (barHeight < 1.5) return; // skip sub-pixel bars

    final rect = Rect.fromLTWH(left, size.height - barHeight, width, barHeight);

    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: cornerRadius,
      topRight: cornerRadius,
    );

    canvas.drawRRect(
      rrect,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _BarsPainter old) =>
      old.data != data ||
      old.followerAnims != followerAnims ||
      old.clickAnims != clickAnims;
}

// ─────────────────────────────────────────────────────────────
// X-AXIS LABELS
//
//  Label is centered under the visual group span:
//    span = barWidth + _kPeekOffset   (followers left → clicks right)
//    center X = slotLeft + (barWidth + _kPeekOffset) / 2
//             = slotLeft + span / 2
//
//  Labels shown at indices 0, mid, last to match the reference image.
// ─────────────────────────────────────────────────────────────

class _XAxisLabels extends StatelessWidget {
  const _XAxisLabels({required this.data});

  final List<StatisticData> data;

  String _fmt(DateTime dt) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dt.day} ${months[dt.month]}';
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final count = data.length;
    // Three evenly-spaced label indices mirroring the reference image.
    final labelIndices = <int>{0, count ~/ 2, count - 1};

    return LayoutBuilder(
      builder: (_, constraints) {
        final slotWidth =
            (constraints.maxWidth - _kGroupGap * (count - 1)) / count;
        final barWidth = slotWidth * _kBarFraction;

        // Visual group span = followers bar + clicks peek
        final groupSpan = barWidth + _kPeekOffset;
        // Width of a label widget (wide enough for "23 Jan 2023")
        const labelWidth = 56.0;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            for (final idx in labelIndices)
              if (idx < count)
                Builder(
                  builder: (_) {
                    final slotLeft = idx * (slotWidth + _kGroupGap);
                    final centerX = slotLeft + groupSpan / 2;
                    return Positioned(
                      left: centerX - labelWidth / 2,
                      top: 5,
                      child: SizedBox(
                        width: labelWidth,
                        child: Text(
                          _fmt(data[idx].dateTime),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 9.5,
                            color: AccountStatsTheme.axisLabel,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                      ),
                    );
                  },
                ),
          ],
        );
      },
    );
  }
}
