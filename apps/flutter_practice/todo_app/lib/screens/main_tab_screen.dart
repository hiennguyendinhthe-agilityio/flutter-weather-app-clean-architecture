import 'package:flutter/cupertino.dart';
import 'package:todo_app/screens/activity_screen.dart.dart';
import 'package:todo_app/screens/advanced_scroll_view_screen.dart';

class MainTabScreen extends StatelessWidget {
  const MainTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_fill),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: 'Activity',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) {
                return const AdvancedScrollViewScreen();
              },
            );
          case 1:
            return CupertinoTabView(
              builder: (context) {
                return const ActivityScreen();
              },
            );
          default:
            return CupertinoTabView(
              builder: (context) {
                return const AdvancedScrollViewScreen();
              },
            );
        }
      },
    );
  }
}
