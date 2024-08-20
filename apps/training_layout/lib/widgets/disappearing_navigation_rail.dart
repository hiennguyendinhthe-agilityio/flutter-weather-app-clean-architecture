import 'package:flutter/material.dart';
import 'package:training_layout/animations.dart';
import 'package:training_layout/destinations.dart';
import 'package:training_layout/transitions/nav_rail_transition.dart';
import 'package:training_layout/widgets/animated_floating_action_button.dart';

class DisappearingNavigationRail extends StatelessWidget {
  const DisappearingNavigationRail({
    required this.backgroundColor,
    required this.selectedIndex,
    required this.railAnimation,
    required this.railFabAnimation,
    super.key,
    this.onDestinationSelected,
  });

  final Color backgroundColor;
  final int selectedIndex;
  final RailAnimation railAnimation;
  final RailFabAnimation railFabAnimation;
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavRailTransition(
      animation: railAnimation,
      backgroundColor: backgroundColor,
      child: NavigationRail(
        onDestinationSelected: onDestinationSelected,
        leading: Column(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu),
            ),
            const SizedBox(
              height: 8,
            ),
            AnimatedFloatingActionButton(
              animation: railFabAnimation,
              elevation: 0,
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ],
        ),
        destinations: destinations.map((d) {
          return NavigationRailDestination(
            icon: Icon(d.icon),
            label: Text(d.label),
          );
        }).toList(),
        selectedIndex: selectedIndex,
        groupAlignment: -0.85,
      ),
    );
  }
}
