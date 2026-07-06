// Data Mapper — Weather.
//
// Rules:
//   - Transforms Data Models ([CurrentWeatherModel]) into Domain Entities ([WeatherEntity]).
//   - Isolates mapping logic so the Repository stays clean.
//   - Handles data conversions (e.g., Unix timestamp int -> DateTime).

import 'package:weather_app/features/weather/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';

abstract final class WeatherMapper {
  WeatherMapper._();

  static WeatherEntity toEntity(CurrentWeatherModel model) {
    // OpenWeatherMap returns weather as an array. Usually, the primary
    // condition is the first item. We safely fallback if it's empty.
    final weatherDesc = model.weather.isNotEmpty
        ? model.weather.first.description
        : 'Unknown';
    final iconCode = model.weather.isNotEmpty
        ? model.weather.first.icon
        : '01d'; // default clear sky day

    // Calculate precise local times by shifting UTC time by the timezone offset
    DateTime getLocalTime(int unixSeconds) {
      final utcTime = DateTime.fromMillisecondsSinceEpoch(
        unixSeconds * 1000,
        isUtc: true,
      );
      return utcTime.add(Duration(seconds: model.timezone));
    }

    return WeatherEntity(
      cityName: model.name,
      countryCode: model.sys.country,
      temperature: model.main.temp,
      feelsLike: model.main.feelsLike,
      minTemp: model.main.tempMin,
      maxTemp: model.main.tempMax,
      condition: weatherDesc,
      iconCode: iconCode,
      humidity: model.main.humidity,
      windSpeed: model.wind.speed,
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(model.dt * 1000),
      localTime: getLocalTime(model.dt),
      sunriseTime: getLocalTime(model.sys.sunrise),
      sunsetTime: getLocalTime(model.sys.sunset),
    );
  }
}
