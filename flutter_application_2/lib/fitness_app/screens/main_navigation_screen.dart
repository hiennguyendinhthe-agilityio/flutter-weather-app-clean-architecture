import 'package:flutter/material.dart';
import 'package:flutter_application_2/fitness_app/screens/expenses_dashboard_screen.dart';
import 'package:flutter_application_2/fitness_app/screens/sales_kpis_screen.dart';

import '../constants/colors.dart';
import 'fitness_goals_screen.dart';
import 'health_stats_screen.dart';
import 'projects_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FitnessGoalsScreen(),
    const ProjectsScreen(),
    const HealthStatsScreen(),
    const ExpensesDashboardScreen(),
    const SalesKpisScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FitnessColors.background,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: FitnessColors.cardBorder.withValues(alpha: 0.5),
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: FitnessColors.background,
          selectedItemColor: FitnessColors.activity,
          unselectedItemColor: FitnessColors.textSecondary.withValues(
            alpha: 0.5,
          ),
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.grid_view_rounded),
              ),
              label: 'Goals',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.widgets_rounded),
              ),
              label: 'Projects',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.insert_chart_rounded),
              ),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.pie_chart_rounded),
              ),
              label: 'Expenses',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.analytics_rounded),
              ),
              label: 'Sales',
            ),
          ],
        ),
      ),
    );
  }
}
