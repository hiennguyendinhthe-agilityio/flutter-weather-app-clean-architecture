// Domain Entity — Weather.
//
// Rules:
//   - PURE Dart. No API logic, no JSON serialization tags (@JsonKey).
//   - Only contains fields that the UI actually cares about.
//   - Uses standard Dart types (e.g., [DateTime] instead of Unix int).
//   - Can still use Freezed for immutability and equality if desired,
//     but for maximum framework independence, we use a plain Dart class
//     (or Freezed without json_serializable). Here we use Freezed purely
//     for value equality and copyWith, keeping it clean of API concerns.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_entity.freezed.dart';

@freezed
abstract class WeatherEntity with _$WeatherEntity {
  const factory WeatherEntity({
    required String cityName,

    required String countryCode,

    required double temperature,

    required double feelsLike,

    required double minTemp,

    required double maxTemp,

    required String condition,

    required String iconCode,

    required int humidity,

    required double windSpeed,

    required DateTime lastUpdated,

    required DateTime localTime,

    required DateTime sunriseTime,

    required DateTime sunsetTime,
  }) = _WeatherEntity;
}
