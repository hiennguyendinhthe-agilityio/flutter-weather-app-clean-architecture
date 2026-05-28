import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_2/chart_demo/screens/account_statistics_screen.dart';

import 'package:flutter_application_2/fitness_app/features/fitness/screens/fitness_goals_screen.dart';
import 'package:flutter_application_2/fitness_app/features/projects/screens/projects_screen.dart';
import 'package:flutter_application_2/fitness_app/features/fitness/screens/health_stats_screen.dart';
import 'package:flutter_application_2/fitness_app/features/expenses/screens/expenses_dashboard_screen.dart';
import 'package:flutter_application_2/fitness_app/features/sales/screens/sales_kpis_screen.dart';
import 'package:flutter_application_2/fitness_app/features/navigation/screens/main_navigation_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/goals',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // MainNavigationScreen giờ đây chỉ là cái khung chứa BottomNavigationBar
        return MainNavigationScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/goals',
              builder: (context, state) => const FitnessGoalsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/projects',
              builder: (context, state) => const ProjectsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stats',
              builder: (context, state) => const HealthStatsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/expenses',
              builder: (context, state) => const ExpensesDashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/sales',
              builder: (context, state) => const SalesKpisScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/account_stats',
              builder: (context, state) => const AccountStatisticsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
