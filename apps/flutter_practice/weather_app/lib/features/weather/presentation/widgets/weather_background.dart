import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/presentation/widgets/fog_overlay.dart';
import 'package:weather_app/features/weather/presentation/widgets/rain_overlay.dart';
import 'package:weather_app/features/weather/presentation/widgets/snow_overlay.dart';
import 'package:weather_app/features/weather/presentation/widgets/sun_rays_overlay.dart';
import 'package:weather_app/features/weather/presentation/widgets/wind_overlay.dart';

/// Maps a weather entity to one of the landscape background images.
String _bgAsset(WeatherEntity? weather) {
  if (weather == null) {
    return 'assets/images/bg_sunny.png';
  }

  final iconCode = weather.iconCode;

  // Extreme Sun / Hot
  if (iconCode == '01d' && weather.temperature > 32) {
    return 'assets/images/bg_hot.png';
  }

  // Snow
  if (iconCode.startsWith('13')) {
    return 'assets/images/bg_snow.png';
  }

  // Freezing cold but not snowing
  if (weather.temperature < 5) {
    return 'assets/images/bg_snow.png';
  }

  // Fog / Mist
  if (iconCode.startsWith('50')) {
    return 'assets/images/bg_fog.png';
  }
  // Rain & storm
  if (['09d', '09n', '10d', '10n', '11d', '11n'].contains(iconCode)) {
    return 'assets/images/bg_rainy.png';
  }
  // Night codes
  if (iconCode.endsWith('n')) {
    return 'assets/images/bg_night.png';
  }

  // Default: sunny/cloudy day
  return 'assets/images/bg_sunny.png';
}

class WeatherBackground extends StatelessWidget {
  final WeatherEntity? weather;

  const WeatherBackground({super.key, this.weather});

  @override
  Widget build(BuildContext context) {
    final asset = _bgAsset(weather);
    final iconCode = weather?.iconCode ?? '';

    // Decouple overlays from background image string
    final isRaining = [
      '09d',
      '09n',
      '10d',
      '10n',
      '11d',
      '11n',
    ].contains(iconCode);
    final isSnowing = iconCode.startsWith('13');
    final isFoggy = iconCode.startsWith('50');

    final isHot = iconCode == '01d' && (weather?.temperature ?? 0) >= 30;

    final isWindy = (weather?.windSpeed ?? 0) > 6.0;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      child: Stack(
        key: ValueKey(
          '${asset}_${isRaining}_${isSnowing}_${isFoggy}_${isHot}_$isWindy',
        ),
        fit: StackFit.expand,
        children: [
          Image.asset(asset, fit: BoxFit.cover),
          if (isRaining) const Positioned.fill(child: RainOverlay()),
          if (isSnowing) const Positioned.fill(child: SnowOverlay()),
          if (isFoggy) const Positioned.fill(child: FogOverlay()),
          if (isHot) const Positioned.fill(child: SunRaysOverlay()),
          if (isWindy) const Positioned.fill(child: WindOverlay()),
        ],
      ),
    );
  }
}
