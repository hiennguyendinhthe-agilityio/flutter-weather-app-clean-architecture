import 'package:flutter/material.dart';
import 'package:task_management_app/presentation/pages/account_page.dart';
import 'package:task_management_app/presentation/pages/pomodoro_page.dart';
import 'package:task_management_app/presentation/pages/report_page.dart';
import 'package:task_management_app/presentation/pages/task_page/task_page.dart';
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
