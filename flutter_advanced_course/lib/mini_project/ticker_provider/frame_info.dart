class FrameInfo {
  final double value;
  final String status;
  final bool isAnimating;
  final double velocity;

  const FrameInfo({
    required this.value,
    required this.status,
    required this.isAnimating,
    required this.velocity,
  });

  factory FrameInfo.empty() => const FrameInfo(
        value: 0,
        status: 'dismissed',
        isAnimating: false,
        velocity: 0,
      );
}
