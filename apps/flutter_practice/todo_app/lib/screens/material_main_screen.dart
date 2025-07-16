import 'package:flutter/material.dart';
import 'package:todo_app/screens/activity_screen.dart.dart';
import 'package:todo_app/screens/advanced_scroll_view_screen.dart';
import 'package:todo_app/screens/painter_demo_screen.dart';

class MaterialMainScreen extends StatefulWidget {
  const MaterialMainScreen({super.key});

  @override
  State<MaterialMainScreen> createState() => _MaterialMainScreenState();
}

class _MaterialMainScreenState extends State<MaterialMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AdvancedScrollViewScreen(),
    const ActivityScreen(),
    const MaterialPainterDemoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Activity',
          ),
          NavigationDestination(
            icon: Icon(Icons.palette_outlined),
            selectedIcon: Icon(Icons.palette),
            label: 'Painter',
          ),
        ],
      ),
    );
  }
}
