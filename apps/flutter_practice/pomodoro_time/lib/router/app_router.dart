import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management_app/presentation/pages/account_page.dart';
import 'package:task_management_app/presentation/pages/calendar/calendar_page.dart';
import 'package:task_management_app/presentation/pages/play_page.dart';
import 'package:task_management_app/presentation/pages/report_page.dart';
import 'package:task_management_app/presentation/pages/task_page.dart';
import 'package:task_management_app/presentation/pages/timer/timer_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/timer',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return NavigationScaffold(child: child);
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

class NavigationScaffold extends StatelessWidget {
  final Widget child;
  const NavigationScaffold({super.key, required this.child});

  static final List<String> _routes = [
    '/timer',
    '/task',
    '/play',
    '/report',
    '/account',
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    int currentIndex = _routes.indexWhere((r) => location.startsWith(r));
    if (currentIndex == -1) currentIndex = 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          context.go(_routes[index]);
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            label: 'Timer',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.task_outlined),
            label: 'Task',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.blue,
                size: 30,
              ),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Report',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
