import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/chart_demo/screens/account_statistics_screen.dart';
import 'package:flutter_advanced_course/fitness_app/features/dashboard/screens/fitness_goals_screen.dart';
import 'package:flutter_advanced_course/fitness_app/features/navigation/screens/main_navigation_screen.dart';
import 'package:flutter_advanced_course/fitness_app/features/profile/screens/profile_screen.dart';
import 'package:flutter_advanced_course/fitness_app/features/sandbox/expenses/screens/expenses_dashboard_screen.dart';
import 'package:flutter_advanced_course/fitness_app/features/sandbox/projects/screens/projects_screen.dart';
import 'package:flutter_advanced_course/fitness_app/features/sandbox/sales/screens/sales_kpis_screen.dart';
import 'package:flutter_advanced_course/fitness_app/features/stats/models/health_stats_data.dart';
import 'package:flutter_advanced_course/fitness_app/features/stats/screens/activity_detail_screen.dart';
import 'package:flutter_advanced_course/fitness_app/features/stats/screens/health_stats_screen.dart';
import 'package:flutter_advanced_course/fitness_app/features/workouts/screens/workouts_screen.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainNavigationScreen(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: Dashboard
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const FitnessGoalsScreen(),
            ),
          ],
        ),
        // Tab 2: Workouts
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/workouts',
              builder: (context, state) => const WorkoutsScreen(),
            ),
          ],
        ),
        // Tab 3: Analytics (formerly Stats)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/analytics',
              builder: (context, state) => const HealthStatsScreen(),
              routes: [
                GoRoute(
                  path: 'activity',
                  pageBuilder: (context, state) {
                    final activity = state.extra as ActivityLevelData;
                    return CustomTransitionPage(
                      key: state.pageKey,
                      child: ActivityDetailScreen(activity: activity),
                      transitionDuration: const Duration(milliseconds: 600),
                      reverseTransitionDuration: const Duration(
                        milliseconds: 600,
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        // Tab 4: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // Root-level routes for the Sandbox sub-screens (hides bottom bar when opened)
    GoRoute(
      path: '/projects',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ProjectsScreen(),
    ),
    GoRoute(
      path: '/expenses',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ExpensesDashboardScreen(),
    ),
    GoRoute(
      path: '/sales',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SalesKpisScreen(),
    ),
    GoRoute(
      path: '/account_stats',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AccountStatisticsScreen(),
    ),
  ],
);
