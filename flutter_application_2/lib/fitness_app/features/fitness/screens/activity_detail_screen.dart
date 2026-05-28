import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../models/health_stats_data.dart';

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

    // Bắt đầu animation sau khi chuyển trang một chút xíu để tạo cảm giác mượt mà
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
    return Scaffold(
      backgroundColor: FitnessColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: FitnessColors.textPrimary,
            size: 24,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(widget.activity.name, style: FitnessTextStyles.titleLarge),
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
                      color: FitnessColors.activity,
                      boxShadow: [
                        BoxShadow(
                          color: FitnessColors.activity.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        widget.activity.icon,
                        size: 60,
                        color: FitnessColors.activityCardBg,
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
                            color: FitnessColors.activity,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Completion Rate',
                          style: FitnessTextStyles.statsCardLabel,
                        ),

                        const SizedBox(height: 40),

                        // Fake detailed stats cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Time',
                                '1h 24m',
                                Icons.timer_outlined,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'Burned',
                                '420 kcal',
                                Icons.local_fire_department_outlined,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Action button
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: FitnessColors.activity,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: FitnessColors.activity.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Start New Session',
                              style: TextStyle(
                                color: FitnessColors.background,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FitnessColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FitnessColors.cardBorder, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: FitnessColors.textSecondary, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: FitnessTextStyles.titleLarge.copyWith(fontSize: 20),
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
