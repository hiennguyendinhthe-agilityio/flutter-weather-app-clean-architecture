import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/constants/text_styles.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';
import 'package:flutter_advanced_course/fitness_app/features/stats/models/health_stats_data.dart';

class ActivityDetailScreen extends StatefulWidget {
  final ActivityLevelData activity;

  const ActivityDetailScreen({super.key, required this.activity});

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    return Scaffold(
      backgroundColor: cs.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface, size: 24),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          widget.activity.name,
          style: FitnessTextStyles.titleLarge.copyWith(color: cs.onSurface),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // ── Hero Animation Container ──
                Hero(
                  tag: 'activity_icon_${widget.activity.name}',
                  flightShuttleBuilder:
                      (
                        flightContext,
                        animation,
                        flightDirection,
                        fromHeroContext,
                        toHeroContext,
                      ) {
                        return ScaleTransition(
                          scale: animation.drive(
                            Tween<double>(
                              begin: 0.8,
                              end: 1.0,
                            ).chain(CurveTween(curve: Curves.easeOutCubic)),
                          ),
                          child: toHeroContext.widget,
                        );
                      },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cs.secondary,
                      boxShadow: [
                        BoxShadow(
                          color: cs.secondary.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        widget.activity.icon,
                        size: 60,
                        color: cs.onSecondary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ── Animated Content ──
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        Text(
                          '${widget.activity.percentage.toInt()}%',
                          style: FitnessTextStyles.titleLarge.copyWith(
                            fontSize: 48,
                            color: cs.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Completion Rate',
                          style: FitnessTextStyles.statsCardLabel.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Real detailed stats cards with actual data
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Duration',
                                _formatDuration(
                                  widget.activity.durationMinutes,
                                ),
                                Icons.timer_outlined,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'Burned',
                                '${widget.activity.caloriesBurned} kcal',
                                Icons.local_fire_department_outlined,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) {
      return '${hours}h';
    }
    return '${hours}h ${mins}m';
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    final cs = context.cs;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: cs.primary, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: FitnessTextStyles.titleLarge.copyWith(
              fontSize: 20,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: FitnessTextStyles.statsCardLabel.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
