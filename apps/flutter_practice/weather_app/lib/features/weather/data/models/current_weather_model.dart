// Data model — Current Weather.
//
// Mirrors the OpenWeatherMap `/data/2.5/weather` response.
// Freezed + JsonSerializable: immutable, copyWith, ==, fromJson/toJson.
//
// Nested models are co-located in this file:
//   - [WeatherConditionModel]  — weather[0] array item
//   - [CurrentMainModel]       — main object (temp, humidity, etc.)
//   - [WindModel]              — wind object
//   - [SysModel]               — sys object (country, sunrise, sunset)

import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_weather_model.freezed.dart';
part 'current_weather_model.g.dart';

// ── Top-level model ────────────────────────────────────────────────────────

@freezed
abstract class CurrentWeatherModel with _$CurrentWeatherModel {
  const factory CurrentWeatherModel({
    /// City name, e.g. "Da Nang"
    required String name,

    /// Weather condition list (normally 1 item)
    required List<WeatherConditionModel> weather,

    /// Temperature + humidity data
    required CurrentMainModel main,

    /// Wind data
    required WindModel wind,

    /// Country + sunrise/sunset
    required SysModel sys,

    /// Unix timestamp (UTC)
    required int dt,

    /// Timezone offset in seconds from UTC
    required int timezone,

    /// OWM city ID
    required int id,
  }) = _CurrentWeatherModel;

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherModelFromJson(json);
}

// ── Nested: weather condition ──────────────────────────────────────────────

@freezed
abstract class WeatherConditionModel with _$WeatherConditionModel {
  const factory WeatherConditionModel({
    required int id,
    required String main,
    required String description,
    required String icon,
  }) = _WeatherConditionModel;

  factory WeatherConditionModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherConditionModelFromJson(json);
}

// ── Nested: main (temperature block) ──────────────────────────────────────

@freezed
abstract class CurrentMainModel with _$CurrentMainModel {
  const factory CurrentMainModel({
    /// Current temperature (°C with metric units)
    required double temp,

    /// Feels-like temperature
    @JsonKey(name: 'feels_like') required double feelsLike,

    /// Daily minimum
    @JsonKey(name: 'temp_min') required double tempMin,

    /// Daily maximum
    @JsonKey(name: 'temp_max') required double tempMax,

    /// Atmospheric pressure (hPa)
    required int pressure,

    /// Humidity (%)
    required int humidity,
  }) = _CurrentMainModel;

  factory CurrentMainModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentMainModelFromJson(json);
}

// ── Nested: wind ──────────────────────────────────────────────────────────

@freezed
abstract class WindModel with _$WindModel {
  const factory WindModel({
    /// Wind speed (m/s with metric units)
    required double speed,

    /// Wind direction (degrees)
    required int deg,
  }) = _WindModel;

  factory WindModel.fromJson(Map<String, dynamic> json) =>
      _$WindModelFromJson(json);
}

// ── Nested: sys ───────────────────────────────────────────────────────────

@freezed
abstract class SysModel with _$SysModel {
  const factory SysModel({
    /// ISO 3166-1 alpha-2 country code, e.g. "VN"
    required String country,

    /// Sunrise Unix timestamp (UTC)
    required int sunrise,

    /// Sunset Unix timestamp (UTC)
    required int sunset,
  }) = _SysModel;

  factory SysModel.fromJson(Map<String, dynamic> json) =>
      _$SysModelFromJson(json);
}
