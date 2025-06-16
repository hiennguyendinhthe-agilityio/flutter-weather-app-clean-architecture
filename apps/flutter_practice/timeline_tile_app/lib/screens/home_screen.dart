import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/theme_service.dart';
import '../widgets/date_selector.dart';
import '../widgets/event_summary_panel.dart';
import '../widgets/pomodoro_timer.dart';
import '../widgets/timeline_view.dart';

/// Main home screen containing the timeline interface
///
/// Provides responsive layout with date selector, timeline view,
/// and optional side panel for larger screens.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showPomodoroTimer = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beautiful Timeline'),
        actions: [
          Consumer<ThemeService>(
            builder: (context, themeService, child) {
              return IconButton(
                icon: Icon(
                  themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: themeService.toggleTheme,
                tooltip: 'Toggle theme',
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _showPomodoroTimer = true;
          });
        },
        icon: const Icon(Icons.timer),
        label: const Text('Start Pomodoro'),
        tooltip: 'Start a 25-minute Pomodoro session',
      ),
      // Pomodoro timer overlay
      body: _showPomodoroTimer
          ? Stack(
              children: [
                // Main content (dimmed)
                Column(
                  children: [
                    const DateSelector(),
                    Expanded(
                      child: isWideScreen
                          ? _buildWideLayout()
                          : _buildNarrowLayout(),
                    ),
                  ],
                ),
                // Pomodoro overlay
                PomodoroTimer(
                  onClose: () {
                    setState(() {
                      _showPomodoroTimer = false;
                    });
                  },
                ),
              ],
            )
          : Column(
              children: [
                const DateSelector(),
                Expanded(
                  child:
                      isWideScreen ? _buildWideLayout() : _buildNarrowLayout(),
                ),
              ],
            ),
    );
  }

  /// Layout for wide screens (tablets, desktop)
  Widget _buildWideLayout() {
    return Row(
      children: [
        // Timeline view (2/3 of width)
        const Expanded(
          flex: 2,
          child: TimelineView(),
        ),

        // Divider
        Container(
          width: 1,
          color: Theme.of(context).dividerColor,
        ),

        // Event summary panel (1/3 of width)
        const Expanded(
          flex: 1,
          child: EventSummaryPanel(),
        ),
      ],
    );
  }

  /// Layout for narrow screens (mobile)
  Widget _buildNarrowLayout() {
    return const TimelineView();
  }
}
