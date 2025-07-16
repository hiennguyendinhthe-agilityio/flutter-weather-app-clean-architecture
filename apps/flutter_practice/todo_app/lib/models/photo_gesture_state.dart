import 'package:flutter/material.dart';

/// Immutable state model for photo gesture interactions
@immutable
class PhotoGestureState {
  final Offset dragOffset;
  final double scale;
  final double backgroundOpacity;

  const PhotoGestureState({
    required this.dragOffset,
    required this.scale,
    required this.backgroundOpacity,
  });

  factory PhotoGestureState.initial() {
    return const PhotoGestureState(
      dragOffset: Offset.zero,
      scale: 1.0,
      backgroundOpacity: 1.0,
    );
  }

  PhotoGestureState copyWith({
    Offset? dragOffset,
    double? scale,
    double? backgroundOpacity,
  }) {
    return PhotoGestureState(
      dragOffset: dragOffset ?? this.dragOffset,
      scale: scale ?? this.scale,
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhotoGestureState &&
        other.dragOffset == dragOffset &&
        other.scale == scale &&
        other.backgroundOpacity == backgroundOpacity;
  }

  @override
  int get hashCode {
    return dragOffset.hashCode ^ scale.hashCode ^ backgroundOpacity.hashCode;
  }
}