import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_background.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_search_bar.dart';
import 'package:weather_app/theme/theme_context_ext.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _searchAnimController;

  @override
  void initState() {
    super.initState();
    _searchAnimController = AnimationController(vsync: this, duration: 300.ms);
  }

  @override
  void dispose() {
    _searchAnimController.dispose();
    super.dispose();
  }

  void _openSearch() {
    _searchAnimController.forward();
  }

  void _closeSearch() {
    FocusScope.of(context).unfocus();
    _searchAnimController.reverse();
  }

  List<Color> _getGradientOverlayColors(WeatherEntity? w) {
    final defaultColors = [
      Colors.black.withAlpha(100),
      Colors.transparent,
      Colors.transparent,
      Colors.white.withAlpha(200),
    ];

    if (w == null) return defaultColors;

    final now = w.localTime;
    final sunrise = w.sunriseTime;
    final sunset = w.sunsetTime;

    final dawnStart = sunrise.subtract(const Duration(minutes: 45));
    final dawnEnd = sunrise.add(const Duration(minutes: 15));
    final duskStart = sunset.subtract(const Duration(minutes: 45));
    final duskEnd = sunset.add(const Duration(minutes: 15));

    if (now.isAfter(dawnStart) && now.isBefore(dawnEnd)) {
      return [
        Colors.deepOrange.withAlpha(80),
        Colors.transparent,
        Colors.transparent,
        Colors.orangeAccent.withAlpha(150),
      ];
    } else if (now.isAfter(duskStart) && now.isBefore(duskEnd)) {
      return [
        Colors.indigo.withAlpha(100),
        Colors.deepOrange.withAlpha(50),
        Colors.transparent,
        Colors.orange.withAlpha(180),
      ];
    } else if (now.isAfter(dawnEnd) && now.isBefore(duskStart)) {
      return defaultColors;
    } else {
      return [
        Colors.black.withAlpha(150),
        Colors.black.withAlpha(50),
        Colors.black.withAlpha(50),
        Colors.black.withAlpha(220),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherProvider);
    final weather = weatherState.value;

    return Scaffold(
      backgroundColor: context.colors.surface,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ── Layer 1: Landscape illustration ────────────────────────────
          Positioned.fill(child: WeatherBackground(weather: weather)),

          // ── Layer 2: Gradient overlay (top dark, bottom light) ─────────
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.35, 0.7, 1.0],
                  colors: _getGradientOverlayColors(weather),
                ),
              ),
            ),
          ),

          // ── Layer 3: Main UI (Slivers) ─────────────────────────────────
          SafeArea(
            bottom: false,
            child: weatherState.when(
              data: (w) =>
                  w == null ? _buildInitialState() : _buildWeatherLayout(w),
              loading: () => _buildLoadingState(),
              error: (e, _) => _buildErrorState(),
            ),
          ),

          // ── Layer 4: Tap outside to close ──────────────────────────────
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _searchAnimController,
              builder: (context, child) {
                if (_searchAnimController.isDismissed) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: _closeSearch,
                  behavior: HitTestBehavior.translucent,
                  child: Container(color: Colors.transparent),
                );
              },
            ),
          ),

          // ── Layer 5: Search overlay (Animated) ─────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _searchAnimController,
              builder: (context, child) {
                return IgnorePointer(
                  ignoring: _searchAnimController.isDismissed,
                  child: child,
                );
              },
              child: Animate(
                controller: _searchAnimController,
                autoPlay: false,
                effects: [
                  SlideEffect(
                    begin: const Offset(0, -1),
                    end: Offset.zero,
                    duration: 350.ms,
                    curve: Curves.easeOutCubic,
                  ),
                ],
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      color: Colors.black.withAlpha(150),
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: WeatherSearchBar(
                                  onSubmitted: _closeSearch,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: context.glass.iconPrimary,
                                ),
                                onPressed: _closeSearch,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherLayout(WeatherEntity w) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Pinned Top Bar ───────────────────────────────────────────────
        SliverAppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          pinned: true,
          toolbarHeight: 64,
          title: Row(
            children: [
              Icon(
                Icons.location_on,
                color: context.glass.iconPrimary,
                size: 18,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  w.cityName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.glass.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    shadows: const [
                      Shadow(blurRadius: 8, color: Colors.black38),
                    ],
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.3, end: 0),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  color: context.glass.iconPrimary,
                ),
                onPressed: _openSearch,
                style: IconButton.styleFrom(
                  backgroundColor: context.glass.searchBackground,
                  shape: const CircleBorder(),
                ),
              ).animate().fadeIn(duration: 600.ms),
            ),
          ],
        ),

        // ── Main Content (Temp + Bottom Card) ────────────────────────────
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Temp & Condition Row
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Temperature
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                              '${w.temperature.toStringAsFixed(0)}°',
                              style: TextStyle(
                                color: context.glass.textPrimary,
                                fontSize: 120,
                                fontWeight: FontWeight.w200,
                                height: 1,
                                shadows: const [
                                  Shadow(blurRadius: 20, color: Colors.black26),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 200.ms, duration: 700.ms)
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              duration: 700.ms,
                              curve: Curves.easeOutCubic,
                            ),
                        Text(
                          _formatDate(w.lastUpdated),
                          style: TextStyle(
                            color: context.glass.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ).animate().fadeIn(delay: 400.ms),
                      ],
                    ),

                    // Rotated Condition
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child:
                          RotatedBox(
                                quarterTurns: 1,
                                child: Text(
                                  _toTitleCase(w.condition),
                                  style: TextStyle(
                                    color: context.glass.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.5,
                                    shadows: const [
                                      Shadow(
                                        blurRadius: 8,
                                        color: Colors.black38,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 300.ms, duration: 600.ms)
                              .slideX(begin: 0.5, end: 0),
                    ),
                  ],
                ),
              ),

              // Push the bottom card to the bottom
              const Spacer(),

              // Bottom forecast card
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                    decoration: BoxDecoration(
                      color: context.glass.background,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Handle indicator
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: context.glass.border,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Weather Today',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: context.colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Stats row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(
                              icon: Icons.thermostat_rounded,
                              label: 'Feels like',
                              value: '${w.feelsLike.toStringAsFixed(0)}°',
                            ),
                            _StatItem(
                              icon: Icons.water_drop_rounded,
                              label: 'Humidity',
                              value: '${w.humidity}%',
                            ),
                            _StatItem(
                              icon: Icons.air_rounded,
                              label: 'Wind',
                              value: '${w.windSpeed.toStringAsFixed(0)}m/s',
                            ),
                            _StatItem(
                              icon: Icons.arrow_downward_rounded,
                              label: 'Low',
                              value: '${w.minTemp.toStringAsFixed(0)}°',
                            ),
                            _StatItem(
                              icon: Icons.arrow_upward_rounded,
                              label: 'High',
                              value: '${w.maxTemp.toStringAsFixed(0)}°',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().slideY(
                begin: 1,
                end: 0,
                duration: 600.ms,
                delay: 200.ms,
                curve: Curves.easeOutCubic,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInitialState() {
    return Stack(
      children: [
        // Top search button
        Positioned(
          top: 16,
          right: 16,
          child: IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: context.glass.iconPrimary,
              size: 28,
            ),
            onPressed: _openSearch,
            style: IconButton.styleFrom(
              backgroundColor: context.glass.searchBackground,
              shape: const CircleBorder(),
            ),
          ),
        ),
        Center(
          child:
              Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wb_sunny_outlined,
                        color: context.glass.iconSecondary,
                        size: 80,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Tap 🔍 to search\nfor your city',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.glass.textSecondary,
                          fontSize: 20,
                          height: 1.6,
                        ),
                      ),
                    ],
                  )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    duration: 800.ms,
                    curve: Curves.easeOut,
                  ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Icon(
        Icons.wb_sunny_rounded,
        size: 64,
        color: context.glass.iconSecondary,
      ).animate(onPlay: (c) => c.repeat()).rotate(duration: 2000.ms),
    );
  }

  Widget _buildErrorState() {
    return Stack(
      children: [
        Positioned(
          top: 16,
          right: 16,
          child: IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: context.glass.iconPrimary,
              size: 28,
            ),
            onPressed: _openSearch,
            style: IconButton.styleFrom(
              backgroundColor: context.glass.searchBackground,
              shape: const CircleBorder(),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 72,
                color: context.glass.iconSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'City not found.\nCheck the name and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.glass.textSecondary,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ).animate().shake(hz: 2, duration: 500.ms).fadeIn(),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${days[dt.weekday - 1]}, ${months[dt.month - 1]} ${dt.day}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _toTitleCase(String s) => s
      .split(' ')
      .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: context.colors.primary, size: 24),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: context.colors.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: context.colors.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
