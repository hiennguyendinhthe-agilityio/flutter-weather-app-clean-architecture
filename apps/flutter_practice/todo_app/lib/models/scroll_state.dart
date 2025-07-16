import 'package:flutter/foundation.dart';

/// Immutable state model for scroll-related data
@immutable
class ScrollState {
  final bool isLoading;
  final bool hasMore;
  final bool isNearEnd;
  final double scrollPosition;
  final String? error;

  const ScrollState({
    required this.isLoading,
    required this.hasMore,
    required this.isNearEnd,
    required this.scrollPosition,
    this.error,
  });

  factory ScrollState.initial() {
    return const ScrollState(
      isLoading: false,
      hasMore: true,
      isNearEnd: false,
      scrollPosition: 0.0,
    );
  }

  ScrollState copyWith({
    bool? isLoading,
    bool? hasMore,
    bool? isNearEnd,
    double? scrollPosition,
    String? error,
  }) {
    return ScrollState(
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      isNearEnd: isNearEnd ?? this.isNearEnd,
      scrollPosition: scrollPosition ?? this.scrollPosition,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScrollState &&
        other.isLoading == isLoading &&
        other.hasMore == hasMore &&
        other.isNearEnd == isNearEnd &&
        other.scrollPosition == scrollPosition &&
        other.error == error;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        hasMore.hashCode ^
        isNearEnd.hashCode ^
        scrollPosition.hashCode ^
        error.hashCode;
  }
}