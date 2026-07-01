import 'package:flutter/material.dart';

class StaggerConfig {
  final int intervalMs;

  final int itemDurationMs;

  final bool slideVertical;

  final double slideDistance;

  final Curve curve;

  const StaggerConfig({
    this.intervalMs = 80,
    this.itemDurationMs = 400,
    this.slideVertical = true,
    this.slideDistance = 20.0,
    this.curve = Curves.easeOut,
  });

  static StaggerConfig fast = const StaggerConfig(
    intervalMs: 50,
    itemDurationMs: 300,
  );

  static StaggerConfig slow = const StaggerConfig(
    intervalMs: 120,
    itemDurationMs: 500,
  );

  static StaggerConfig slideFromRigt = const StaggerConfig(
    intervalMs: 80,
    itemDurationMs: 400,
    slideVertical: false,
    slideDistance: 30.0,
    curve: Curves.easeOutCubic,
  );

  static StaggerConfig gentle = const StaggerConfig(
    intervalMs: 100,
    itemDurationMs: 450,
    curve: Curves.easeInOut,
  );
}

class StaggerGroup extends StatefulWidget {
  final List<Widget> children;

  final StaggerConfig config;

  final int initialDelayMs;

  const StaggerGroup({
    super.key,
    required this.children,
    this.config = const StaggerConfig(),
    this.initialDelayMs = 0,
  });

  @override
  State<StaggerGroup> createState() => _StaggerGroupState();
}

class _StaggerGroupState extends State<StaggerGroup>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  late Duration _totalDuration;

  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _buildAnimations();
    _startAfterDelay();
  }

  void _buildAnimations() {
    final count = widget.children.length;
    final cfg = widget.config;

    final totalMs =
        (count > 1 ? (count - 1) * cfg.intervalMs : 0) + cfg.itemDurationMs;

    _totalDuration = Duration(milliseconds: totalMs);

    _controller = AnimationController(vsync: this, duration: _totalDuration);

    _animations = List.generate(count, (i) {
      final startMs = i * cfg.intervalMs;
      final endMs = startMs + cfg.itemDurationMs;

      final start = startMs / totalMs;
      final end = endMs / totalMs;

      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            start.clamp(0.0, 1.0),
            end.clamp(0.0, 1.0),
            curve: cfg.curve,
          ),
        ),
      );
    });

    _controller.addListener(() => setState(() {}));
  }

  void _startAfterDelay() {
    if (widget.initialDelayMs > 0) {
      Future.delayed(Duration(milliseconds: widget.initialDelayMs), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        widget.children.length,
        (i) => _StaggerItemWrapper(
          animation: _animations[i],
          config: widget.config,
          child: widget.children[i],
        ),
      ),
    );
  }
}

class _StaggerItemWrapper extends StatelessWidget {
  final Animation<double> animation;
  final StaggerConfig config;
  final Widget child;

  const _StaggerItemWrapper({
    required this.animation,
    required this.config,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final t = animation.value.clamp(0.0, 1.0);

    final offsetX = config.slideVertical ? 0.0 : (1 - t) * config.slideDistance;

    final offsetY = config.slideVertical ? (1 - t) * config.slideDistance : 0.0;

    return Opacity(
      opacity: t,
      child: Transform.translate(
        offset: Offset(offsetX, offsetY),
        child: child,
      ),
    );
  }
}

class StaggerController {
  _StaggerControlledGroupState? _state;

  void _attach(_StaggerControlledGroupState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  void replay() {
    _state?._replay();
  }

  void reset() {
    _state?._reset();
  }
}

class StaggerControlledGroup extends StatefulWidget {
  final List<Widget> children;
  final StaggerConfig config;
  final int initialDelayMs;
  final StaggerController? controller;

  const StaggerControlledGroup({
    super.key,
    required this.children,
    this.config = const StaggerConfig(),
    this.initialDelayMs = 0,
    this.controller,
  });

  @override
  State<StaggerControlledGroup> createState() => _StaggerControlledGroupState();
}

class _StaggerControlledGroupState extends State<StaggerControlledGroup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
    _build();
    _start();
  }

  @override
  void didUpdateWidget(StaggerControlledGroup old) {
    super.didUpdateWidget(old);

    if (old.children.length != widget.children.length) {
      _animCtrl.dispose();
      _build();
      _replay();
    }
  }

  void _build() {
    final count = widget.children.length;
    final cfg = widget.config;

    final totalMs =
        (count > 1 ? (count - 1) * cfg.intervalMs : 0) + cfg.itemDurationMs;

    _animCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMs),
    );

    _animations = List.generate(count, (i) {
      final startMs = i * cfg.intervalMs;
      final endMs = startMs + cfg.itemDurationMs;
      final start = startMs / totalMs;
      final end = endMs / totalMs;

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animCtrl,
          curve: Interval(
            start.clamp(0.0, 1.0),
            end.clamp(0.0, 1.0),
            curve: cfg.curve,
          ),
        ),
      );
    });

    _animCtrl.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _start() {
    Future.delayed(Duration(milliseconds: widget.initialDelayMs), () {
      if (mounted) _animCtrl.forward();
    });
  }

  void _replay() {
    _animCtrl.reset();
    _animCtrl.forward();
  }

  void _reset() {
    _animCtrl.reset();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller?._detach();
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        widget.children.length,
        (i) => _StaggerItemWrapper(
          animation: _animations[i],
          config: widget.config,
          child: widget.children[i],
        ),
      ),
    );
  }
}
