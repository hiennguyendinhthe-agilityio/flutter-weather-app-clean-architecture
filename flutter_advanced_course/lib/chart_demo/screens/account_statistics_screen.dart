import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/chart_demo/core/account_stats_theme.dart';
import 'package:flutter_advanced_course/chart_demo/models/statistic_data.dart';
import 'package:flutter_advanced_course/chart_demo/widgets/bar_chart/custom_animated_bar_chart.dart';
import 'package:flutter_advanced_course/chart_demo/widgets/chart_legend.dart';
import 'package:flutter_advanced_course/chart_demo/widgets/stat_card.dart';
import 'package:flutter_advanced_course/chart_demo/widgets/user_stat_table.dart';

// ─────────────────────────────────────────────────────────────
// ACCOUNT STATISTICS SCREEN
// ─────────────────────────────────────────────────────────────

class AccountStatisticsScreen extends StatefulWidget {
  const AccountStatisticsScreen({super.key});

  @override
  State<AccountStatisticsScreen> createState() =>
      _AccountStatisticsScreenState();
}

class _AccountStatisticsScreenState extends State<AccountStatisticsScreen> {
  late List<StatisticData> _statistics;
  late final List<AttributedUser> _users;

  @override
  void initState() {
    super.initState();
    _statistics = MockStatisticData.generate();
    _users = MockAttributedUsers.generate();
  }

  void _randomizeData() {
    setState(() {
      _statistics = MockStatisticData.generateRandom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AccountStatsTheme.scaffoldBg,
      appBar: _AccountAppBar(onRandomize: _randomizeData),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Bar Chart Card
              StatCard(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: _BarChartSection(statistics: _statistics),
              ),

              const SizedBox(height: 16),

              // ── Attributed Users Card
              StatCard(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: _AttributedUsersSection(users: _users),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CUSTOM APP BAR
// ─────────────────────────────────────────────────────────────

class _AccountAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AccountAppBar({required this.onRandomize});
  final VoidCallback onRandomize;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AccountStatsTheme.appBarBg,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: preferredSize.height,
          child: Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: AccountStatsTheme.appBarText,
                    size: 22,
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  'Account statistic',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AccountStatsTheme.appBarText,
                    letterSpacing: -0.3,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
              ),
              // Randomize button (balance the back button)
              GestureDetector(
                onTap: onRandomize,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    color: AccountStatsTheme.appBarText,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// BAR CHART SECTION
// ─────────────────────────────────────────────────────────────

class _BarChartSection extends StatelessWidget {
  const _BarChartSection({required this.statistics});
  final List<StatisticData> statistics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        const Text(
          'Followers reached in the last 15 days',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AccountStatsTheme.primaryText,
            letterSpacing: -0.2,
            fontFamily: 'SF Pro Display',
          ),
        ),

        const SizedBox(height: 14),

        // Legend — glassmorphic capsule is self-contained inside ChartLegend.
        const ChartLegend(),

        const SizedBox(height: 20),

        // Chart
        SizedBox(
          height: 180,
          child: CustomAnimatedBarChart(
            data: statistics,
            maxYValue: 15,
            yDivisions: 3,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ATTRIBUTED USERS SECTION
// ─────────────────────────────────────────────────────────────

class _AttributedUsersSection extends StatelessWidget {
  const _AttributedUsersSection({required this.users});
  final List<AttributedUser> users;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          children: [
            const Expanded(
              child: Text(
                'Last 100 attributed users',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AccountStatsTheme.primaryText,
                  letterSpacing: -0.2,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ),
            // "All" filter chip
            _AllFilterChip(),
          ],
        ),

        const SizedBox(height: 20),

        // Table
        UserStatTable(users: users),

        const SizedBox(height: 12),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// "ALL" FILTER CHIP
// ─────────────────────────────────────────────────────────────

class _AllFilterChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AccountStatsTheme.filterBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_alt_outlined,
            color: AccountStatsTheme.filterText,
            size: 14,
          ),
          SizedBox(width: 6),
          Text(
            'All',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AccountStatsTheme.filterText,
              fontFamily: 'SF Pro Display',
            ),
          ),
        ],
      ),
    );
  }
}
