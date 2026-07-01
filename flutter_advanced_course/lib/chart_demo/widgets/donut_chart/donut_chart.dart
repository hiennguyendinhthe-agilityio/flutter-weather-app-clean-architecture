import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_course/chart_demo/core/constants.dart';
import 'package:flutter_advanced_course/chart_demo/models/donut_slice_data.dart';
import 'package:flutter_advanced_course/chart_demo/widgets/donut_chart/donut_chart_painter.dart';
import 'package:flutter_advanced_course/chart_demo/widgets/donut_chart/donut_geometry.dart';

class DonutChart extends StatefulWidget {
  const DonutChart({
    super.key,
    required this.slices,
    this.dimension = DonutDefaults.dimension,
    this.strokeRatio = DonutDefaults.strokeRatio,
    this.sliceInsetRatio = DonutDefaults.sliceInsetRatio,
    this.entryDuration = AppDurations.entryAnimation,
    this.entryCurve = AppCurves.entry,
    this.toggleDuration = AppDurations.toggleAnimation,
    this.toggleCurve = AppCurves.toggle,
    this.selectedIndex,
    this.onSliceSelected,
    this.centerBuilder,
    this.enableHaptics = true,
  });

  final List<DonutSliceData> slices;
  final double dimension;
  final double strokeRatio;
  final double sliceInsetRatio;
  final Duration entryDuration;
  final Curve entryCurve;
  final Duration toggleDuration;
  final Curve toggleCurve;
  final int? selectedIndex;
  final ValueChanged<int?>? onSliceSelected;

  final Widget Function(int? selectedIndex)? centerBuilder;
  final bool enableHaptics;

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> with TickerProviderStateMixin {
  double get _strokeWidth => (widget.dimension / 2) * widget.strokeRatio;
  double get _sliceInset => (widget.dimension / 2) * widget.sliceInsetRatio;

  int? _selectedIndex;
  List<NormalizedSlice> _normalizedSlices = [];

  late AnimationController _entryController;
  late Animation<double> _sweepAnimation;

  final Map<int, AnimationController> _expansionControllers = {};
  final Map<int, Animation<double>> _expansionAnimations = {};
  final Map<int, AnimationController> _colorControllers = {};
  final Map<int, Animation<Color?>> _colorAnimations = {};

  @override
  void initState() {
    super.initState();

    _normalizedSlices = DonutNormalizer.normalize(widget.slices);

    _entryController = AnimationController(
      duration: widget.entryDuration,
      vsync: this,
    );
    _sweepAnimation = CurvedAnimation(
      parent: _entryController,
      curve: widget.entryCurve,
    );

    _initSliceControllers();

    _selectedIndex = widget.selectedIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _entryController.forward();
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _disposeSliceControllers();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DonutChart old) {
    super.didUpdateWidget(old);
    if (old.slices != widget.slices) {
      _disposeSliceControllers();
      _normalizedSlices = DonutNormalizer.normalize(widget.slices);
      _initSliceControllers();

      _entryController.forward(from: 0);
      setState(() => _selectedIndex = null);
    } else if (old.selectedIndex != widget.selectedIndex &&
        widget.selectedIndex != _selectedIndex) {
      _updateSelection(widget.selectedIndex, triggerCallback: false);
    }
  }

  void _initSliceControllers() {
    for (var i = 0; i < _normalizedSlices.length; i++) {
      final slice = _normalizedSlices[i];
      final isSelected = widget.selectedIndex == i;
      final allInactive = widget.selectedIndex == null;

      final expCtrl = AnimationController(
        value: isSelected ? 1.0 : 0.0,
        duration: widget.toggleDuration,
        vsync: this,
      );
      _expansionControllers[i] = expCtrl;
      _expansionAnimations[i] = CurveTween(
        curve: widget.toggleCurve,
      ).animate(expCtrl);

      final colorCtrl = AnimationController(
        value: (isSelected || allInactive) ? 1.0 : 0.0,
        duration: widget.toggleDuration,
        vsync: this,
      );
      _colorControllers[i] = colorCtrl;
      _colorAnimations[i] = ColorTween(
        begin: slice.original.resolvedDimmedColor,
        end: slice.original.color,
      ).animate(colorCtrl);
    }
  }

  void _disposeSliceControllers() {
    for (final c in _expansionControllers.values) {
      c.dispose();
    }
    for (final c in _colorControllers.values) {
      c.dispose();
    }
    _expansionControllers.clear();
    _expansionAnimations.clear();
    _colorControllers.clear();
    _colorAnimations.clear();
  }

  void _handleTap(TapDownDetails details) {
    final size = context.size;
    if (size == null) return;

    final tapped = _hitTest(details.localPosition, size);

    if (tapped == null || tapped == _selectedIndex) {
      _updateSelection(null);
    } else {
      _updateSelection(tapped);
    }
  }

  void _updateSelection(int? newIndex, {bool triggerCallback = true}) {
    if (_selectedIndex == newIndex) return;

    final oldIndex = _selectedIndex;
    setState(() => _selectedIndex = newIndex);

    if (triggerCallback) {
      widget.onSliceSelected?.call(newIndex);
    }

    if (oldIndex != null) _expansionControllers[oldIndex]?.reverse();
    if (newIndex != null) _expansionControllers[newIndex]?.forward();

    for (var i = 0; i < _normalizedSlices.length; i++) {
      final slice = _normalizedSlices[i];
      final isActive = newIndex == null || i == newIndex;
      final targetColor = isActive
          ? slice.original.color
          : slice.original.resolvedDimmedColor;

      final ctrl = _colorControllers[i];
      final anim = _colorAnimations[i];
      if (ctrl == null || anim == null) continue;

      _colorAnimations[i] = ColorTween(
        begin: anim.value,
        end: targetColor,
      ).animate(ctrl);

      ctrl
        ..reset()
        ..forward();
    }

    if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }
  }

  int? _hitTest(Offset position, Size size) {
    final geometry = DonutGeometry(
      slices: _normalizedSlices,
      size: size,
      strokeWidth: _strokeWidth,
      sliceInset: _sliceInset,
      animationValues: Map.fromEntries(
        _expansionAnimations.entries.map((e) => MapEntry(e.key, e.value.value)),
      ),
      sweepProgress: _sweepAnimation.value,
    );
    geometry.buildSlices();

    for (final geo in geometry.sliceGeometries) {
      if (geo.buildPath().contains(position)) return geo.index;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final canInteract = widget.onSliceSelected != null;

    return SizedBox.square(
      dimension: widget.dimension,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.centerBuilder != null)
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(_sliceInset + _strokeWidth + 16),
                child: AnimatedSwitcher(
                  duration: widget.toggleDuration,
                  child: KeyedSubtree(
                    key: ValueKey(_selectedIndex),
                    child: widget.centerBuilder!(_selectedIndex),
                  ),
                ),
              ),
            ),

          GestureDetector(
            onTapDown: canInteract ? _handleTap : null,
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _sweepAnimation,
                ..._expansionAnimations.values,
                ..._colorAnimations.values,
              ]),
              builder: (context, _) {
                return CustomPaint(
                  size: Size.square(widget.dimension),
                  painter: DonutChartPainter(
                    slices: _normalizedSlices,
                    strokeWidth: _strokeWidth,
                    sliceInset: _sliceInset,
                    sweepProgress: _sweepAnimation.value,
                    expansionValues: Map.fromEntries(
                      _expansionAnimations.entries.map(
                        (e) => MapEntry(e.key, e.value.value),
                      ),
                    ),
                    colorValues: Map.fromEntries(
                      _colorAnimations.entries.map(
                        (e) => MapEntry(
                          e.key,
                          e.value.value ??
                              _normalizedSlices[e.key].original.color,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
