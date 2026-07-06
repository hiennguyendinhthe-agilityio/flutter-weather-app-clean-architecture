// State Management — Weather Provider.
//
// Rules:
//   - Uses [AsyncNotifier] (Riverpod 3 standard) to manage asynchronous state.
//   - State type is [WeatherEntity?]. Null means no city has been searched yet.
//   - Relies completely on [AsyncValue] for Loading / Error / Data states.
//   - Interacts ONLY with Domain UseCases ([GetCurrentWeatherUseCase]), never
//     Repositories or Data Sources directly.

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather_usecase.dart';

class WeatherNotifier extends AsyncNotifier<WeatherEntity?> {
  @override
  FutureOr<WeatherEntity?> build() {
    return null;
  }

  Future<void> fetchWeather(String city) async {
    state = const AsyncValue.loading();

    final useCase = ref.read(getCurrentWeatherUseCaseProvider);

    state = await AsyncValue.guard(() => useCase.execute(city: city));
  }
}

final weatherProvider = AsyncNotifierProvider<WeatherNotifier, WeatherEntity?>(
  WeatherNotifier.new,
);
