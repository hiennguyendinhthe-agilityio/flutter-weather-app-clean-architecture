import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherEntity weather;

  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(38),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withAlpha(64), width: 1.5),
          ),
          child: Column(
            children: [
              // ── City Name ──────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white70,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${weather.cityName}, ${weather.countryCode}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 20),

              // ── Floating Icon + Temperature ────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Floating weather icon
                  Image.asset(
                        'assets/icons/${weather.iconCode}.png',
                        width: 110,
                        height: 110,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.cloud,
                              size: 110,
                              color: Colors.white70,
                            ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveY(
                        begin: 0,
                        end: -10,
                        duration: 2000.ms,
                        curve: Curves.easeInOut,
                      ),
                  const SizedBox(width: 8),
                  // Temperature
                  Text(
                        '${weather.temperature.toStringAsFixed(0)}°',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 96,
                          fontWeight: FontWeight.w200,
                          height: 1.0,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 200.ms)
                      .scale(
                        begin: const Offset(0.7, 0.7),
                        duration: 600.ms,
                        curve: Curves.easeOutBack,
                      ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Condition Badge ────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  weather.condition.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 2,
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),

              const SizedBox(height: 16),

              // ── Min/Max ────────────────────────────────────────────────
              Text(
                'Cao ${weather.maxTemp.toStringAsFixed(0)}°  •  Thấp ${weather.minTemp.toStringAsFixed(0)}°',
                style: TextStyle(
                  color: Colors.white.withAlpha(204),
                  fontSize: 15,
                ),
              ).animate().fadeIn(delay: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
