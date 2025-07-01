import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PtNavigationScaffold extends StatelessWidget {
  final Widget child;
  const PtNavigationScaffold({super.key, required this.child});

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
      resizeToAvoidBottomInset: true,
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
            icon: Icon(Icons.timer),
            label: 'Timer',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.task),
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
