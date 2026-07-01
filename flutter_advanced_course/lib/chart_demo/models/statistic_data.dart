import 'dart:math';
import 'package:flutter/foundation.dart';

// ─────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────

@immutable
class StatisticData {
  const StatisticData({
    required this.dateTime,
    required this.followers,
    required this.clicks,
  }) : assert(followers >= 0, 'followers must be non-negative'),
       assert(clicks >= 0, 'clicks must be non-negative');

  final DateTime dateTime;

  /// Followers reached on this day (0–15 range for Y-axis).
  final double followers;

  /// Clicks recorded on this day (0–15 range for Y-axis).
  final double clicks;

  double get maxValue => followers > clicks ? followers : clicks;

  StatisticData copyWith({
    DateTime? dateTime,
    double? followers,
    double? clicks,
  }) {
    return StatisticData(
      dateTime: dateTime ?? this.dateTime,
      followers: followers ?? this.followers,
      clicks: clicks ?? this.clicks,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatisticData &&
          runtimeType == other.runtimeType &&
          dateTime == other.dateTime &&
          followers == other.followers &&
          clicks == other.clicks;

  @override
  int get hashCode => Object.hash(dateTime, followers, clicks);

  @override
  String toString() =>
      'StatisticData(date: $dateTime, followers: $followers, clicks: $clicks)';
}

// ─────────────────────────────────────────────────────────────
// MOCK DATA GENERATOR
// ─────────────────────────────────────────────────────────────

abstract final class MockStatisticData {
  /// Returns 15 data points for the "last 15 days" (ending today).
  static List<StatisticData> generate() {
    // Anchor to Jan 30, 2023 to match the image exactly.
    final anchor = DateTime(2023, 1, 30);

    // Hand-tuned values that produce a visually compelling grouped bar chart
    // matching the silhouette visible in the reference image.
    const raw = <(double, double)>[
      (7.0, 12.0), // Jan 16
      (9.0, 14.0), // Jan 17
      (7.5, 12.5), // Jan 18
      (8.0, 13.0), // Jan 19
      (5.0, 9.0), // Jan 20
      (6.5, 10.5), // Jan 21
      (4.0, 7.0), // Jan 22
      (1.5, 3.5), // Jan 23
      (2.0, 4.0), // Jan 24
      (0.5, 1.5), // Jan 25
      (0.5, 1.0), // Jan 26
      (0.5, 1.5), // Jan 27
      (7.0, 12.0), // Jan 28
      (1.5, 2.5), // Jan 29
      (3.5, 6.0), // Jan 30
    ];

    return List.generate(raw.length, (i) {
      final date = anchor.subtract(Duration(days: raw.length - 1 - i));
      return StatisticData(
        dateTime: date,
        followers: raw[i].$1,
        clicks: raw[i].$2,
      );
    });
  }

  /// Returns 15 random data points to demonstrate animations.
  static List<StatisticData> generateRandom() {
    final anchor = DateTime(2023, 1, 30);
    final random = Random();

    return List.generate(15, (i) {
      final date = anchor.subtract(Duration(days: 15 - 1 - i));

      // Random clicks between 2 and 15
      final clicks = 2.0 + random.nextDouble() * 13.0;

      // Random followers between 0 and clicks
      final followers = random.nextDouble() * (clicks - 0.5);

      return StatisticData(
        dateTime: date,
        followers: followers,
        clicks: clicks,
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────
// ATTRIBUTED USER MODEL
// ─────────────────────────────────────────────────────────────

@immutable
class AttributedUser {
  const AttributedUser({
    required this.nickname,
    required this.date,
    required this.resource,
  });

  final String nickname;
  final DateTime date;
  final String resource;

  String get formattedDate {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year;
    return '$d.$m.$y';
  }
}

// ─────────────────────────────────────────────────────────────
// MOCK ATTRIBUTED USERS GENERATOR
// ─────────────────────────────────────────────────────────────

abstract final class MockAttributedUsers {
  static List<AttributedUser> generate() => [
    AttributedUser(
      nickname: 'TomasJonson',
      date: DateTime(2023, 1, 1),
      resource: '/MTq2nKpo',
    ),
    AttributedUser(
      nickname: 'HueMc543',
      date: DateTime(2022, 12, 30),
      resource: '/MTq2nKpo',
    ),
    AttributedUser(
      nickname: 'new_user87',
      date: DateTime(2022, 12, 30),
      resource: '/ZF4kx9Bh',
    ),
    AttributedUser(
      nickname: 'DiamondMir...',
      date: DateTime(2022, 12, 28),
      resource: '/86fbsKqm',
    ),
    AttributedUser(
      nickname: 'new_user13',
      date: DateTime(2022, 12, 27),
      resource: '/MTq2nKpo',
    ),
    AttributedUser(
      nickname: 'StarGazer99',
      date: DateTime(2022, 12, 25),
      resource: '/ZF4kx9Bh',
    ),
    AttributedUser(
      nickname: 'ByteRunner',
      date: DateTime(2022, 12, 23),
      resource: '/MTq2nKpo',
    ),
    AttributedUser(
      nickname: 'Pixel_Wave',
      date: DateTime(2022, 12, 21),
      resource: '/86fbsKqm',
    ),
    AttributedUser(
      nickname: 'CryptoNova',
      date: DateTime(2022, 12, 19),
      resource: '/MTq2nKpo',
    ),
    AttributedUser(
      nickname: 'LunaVortex',
      date: DateTime(2022, 12, 18),
      resource: '/ZF4kx9Bh',
    ),
  ];
}
