import 'package:go_router/go_router.dart';
import 'package:task_management_app/presentation/pages/account/account_page.dart';
import 'package:task_management_app/presentation/pages/calendar/calendar_page.dart';
import 'package:task_management_app/presentation/pages/play/play_page.dart';
import 'package:task_management_app/presentation/pages/report/report_page.dart';
import 'package:task_management_app/presentation/pages/tasks/task_page.dart';
import 'package:task_management_app/presentation/pages/timer/timer_page.dart';
import 'package:task_management_app/presentation/widgets/navigation_scaffold.dart';

final GoRouter router = GoRouter(
  initialLocation: '/timer',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return PtNavigationScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/timer',
          name: 'timer',
          builder: (context, state) => const TimerPage(),
        ),
        GoRoute(
          path: '/task',
          name: 'task',
          builder: (context, state) => const TaskPage(),
        ),
        GoRoute(
          path: '/play',
          name: 'play',
          builder: (context, state) => const PlayPage(),
        ),
        GoRoute(
          path: '/report',
          name: 'report',
          builder: (context, state) => const ReportPage(),
        ),
        GoRoute(
          path: '/account',
          name: 'account',
          builder: (context, state) => const AccountPage(),
        ),
        GoRoute(
          path: '/calendar',
          name: 'calendar',
          builder: (context, state) => const CalendarPage(),
        ),
      ],
    ),
  ],
);
