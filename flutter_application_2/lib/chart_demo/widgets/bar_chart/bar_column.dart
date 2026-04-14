import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../models/bar_item_data.dart';
import 'bar_chart_painter.dart';

/// Single animated bar column.
/// Mỗi cột tự quản lý AnimationController riêng → stagger hoạt động độc lập.
class BarColumn extends StatefulWidget {
  const BarColumn({
    super.key,
    required this.item,
    required this.maxHeight,
    required this.columnWidth,
    this.borderRadius = BarDefaults.borderRadius,
    this.showLabel = true,
    this.labelStyle,
    this.entryDuration = AppDurations.entryAnimation,
    this.entryDelay = Duration.zero,
    this.entryCurve = AppCurves.entry,
  });

  final BarItemData item;
  final double maxHeight;
  final double columnWidth;
  final double borderRadius;
  final bool showLabel;
  final TextStyle? labelStyle;
  final Duration entryDuration;
  final Duration entryDelay;
  final Curve entryCurve;

  @override
  State<BarColumn> createState() => _BarColumnState();
}

class _BarColumnState extends State<BarColumn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _growAnimation; // 0→1: bottom-up reveal
  late Tween<double> _primaryTween; // tween cho data update
  late Tween<double> _totalTween;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.entryDuration,
      vsync: this,
    );
    _growAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.entryCurve,
    );

    _primaryTween = Tween(begin: 0, end: widget.item.primaryRatio);
    _totalTween = Tween(begin: 0, end: widget.item.totalRatio);

    // Stagger: delay rồi mới animate
    Future.delayed(widget.entryDelay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BarColumn old) {
    super.didUpdateWidget(old);
    if (old.item != widget.item) {
      // Smooth update: tween từ giá trị hiện tại → giá trị mới
      _primaryTween = Tween(
        begin: _primaryTween.evaluate(_growAnimation),
        end: widget.item.primaryRatio,
      );
      _totalTween = Tween(
        begin: _totalTween.evaluate(_growAnimation),
        end: widget.item.totalRatio,
      );
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveLabelStyle =
        widget.labelStyle ??
        Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Bar ─────────────────────────────────────────────────────
        AnimatedBuilder(
          animation: _growAnimation,
          builder: (context, _) {
            return SizedBox(
              width: widget.columnWidth,
              height: widget.maxHeight,
              child: CustomPaint(
                painter: BarColumnPainter(
                  item: widget.item,
                  growProgress: _growAnimation.value,
                  primaryRatio: _primaryTween.evaluate(_growAnimation),
                  totalRatio: _totalTween.evaluate(_growAnimation),
                  borderRadius: widget.borderRadius,
                ),
              ),
            );
          },
        ),

        // ── Label dưới cột ──────────────────────────────────────────
        if (widget.showLabel) ...[
          const SizedBox(height: 6),
          Text(widget.item.label, style: effectiveLabelStyle),
        ],
      ],
    );
  }
}
