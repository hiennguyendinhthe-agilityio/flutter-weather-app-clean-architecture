// Domain Repository Interface — Weather.
//
// Rules:
//   - PURE Dart. No network imports (no Dio, no Retrofit).
//   - Returns Domain Entities ([WeatherEntity]), NEVER Data Models.
//   - Defines WHAT the app can do, not HOW it does it.

import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';

abstract interface class WeatherRepository {
  /// Fetches the current weather for a given city name.
  Future<WeatherEntity> getCurrentWeather({required String city});
}
