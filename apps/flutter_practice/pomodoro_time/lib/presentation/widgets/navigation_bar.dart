import 'package:flutter/material.dart';
import 'package:task_management_app/presentation/pages/account_page.dart';
import 'package:task_management_app/presentation/pages/pomodoro_page.dart';
import 'package:task_management_app/presentation/pages/report_page.dart';
import 'package:task_management_app/presentation/pages/task_page.dart';
import 'package:task_management_app/presentation/pages/timer_page.dart';

class NavigationBarRoute extends StatefulWidget {
  const NavigationBarRoute({super.key});

  @override
  State<NavigationBarRoute> createState() => _NavigationBarRouteState();
}

class _NavigationBarRouteState extends State<NavigationBarRoute> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const TimerPage(),
    const TaskPage(),
    const PomodoroPage(),
    const ReportPage(),
    const AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_outlined),
            label: 'Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            label: 'Play',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
