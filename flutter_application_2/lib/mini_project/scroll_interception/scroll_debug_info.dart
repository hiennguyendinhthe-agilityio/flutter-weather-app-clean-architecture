class ScrollDebugInfo {
  final double pixels;
  final double maxExtent;
  final double viewportDimension;
  final bool atEdge;
  final String phase;
  final double scrollDelta;

  const ScrollDebugInfo({
    required this.pixels,
    required this.maxExtent,
    required this.viewportDimension,
    required this.atEdge,
    required this.phase,
    required this.scrollDelta,
  });

  factory ScrollDebugInfo.empty() => const ScrollDebugInfo(
    pixels: 0,
    maxExtent: 0,
    viewportDimension: 0,
    atEdge: false,
    phase: 'Idle ⚪',
    scrollDelta: 0,
  );

  // Progress: 0% → 100%
  double get progress =>
      maxExtent > 0 ? (pixels / maxExtent).clamp(0.0, 1.0) : 0;
}
