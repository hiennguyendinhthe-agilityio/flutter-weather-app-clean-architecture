import 'package:bazar_books_design/core/constant/route_constants.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/widgets/images/image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class MainNavigation extends StatelessWidget {
  const MainNavigation({
    required this.child,
    this.showBottomNavBar,
    super.key,
  });

  final Widget child;
  final bool? showBottomNavBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _calculateSelectedIndex(context),
          onTap: (int idx) => _onItemTapped(idx, context),
          items: [
            BottomNavigationBarItem(
              icon: BazUiBuiltInImage.icHomeFill(
                  color: context.colorScheme.tertiary),
              label: context.bazS.generalTitleHome,
              activeIcon: BazUiBuiltInImage.icHomeFill(
                  color: context.colorScheme.primary),
            ),
            BottomNavigationBarItem(
              icon: BazUiBuiltInImage.icMenuFill(
                  color: context.colorScheme.tertiary),
              label: context.bazS.generalTitleCategory,
              activeIcon: BazUiBuiltInImage.icMenuFill(
                  color: context.colorScheme.primary),
            ),
            BottomNavigationBarItem(
              icon: BazUiBuiltInImage.icCardFill(
                  color: context.colorScheme.tertiary),
              label: context.bazS.generalTitleCart,
              activeIcon: BazUiBuiltInImage.icCardFill(
                  color: context.colorScheme.primary),
            ),
            BottomNavigationBarItem(
              icon: BazUiBuiltInImage.icProfileFill(
                  color: context.colorScheme.tertiary),
              label: context.bazS.generalTitleProfile,
              activeIcon: BazUiBuiltInImage.icProfileFill(
                  color: context.colorScheme.primary),
            ),
          ],
        ));
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    // Map of route paths to index
    const routeIndexMap = {
      RoutePaths.home: 0,
      RoutePaths.categories: 1,
      RoutePaths.cart: 2,
      RoutePaths.profile: 3,
    };

    // Find the route path with `startsWith`, or default to index 0
    return routeIndexMap.entries
        .firstWhere(
          (entry) => location.startsWith(entry.key),
          orElse: () => const MapEntry(RoutePaths.home, 0),
        )
        .value;
  }

  void _onItemTapped(int index, BuildContext context) {
    // Map of index to route paths
    const indexRouteMap = {
      0: RoutePaths.home,
      1: RoutePaths.categories,
      2: RoutePaths.cart,
      3: RoutePaths.profile,
    };

    // Navigate to route if it exists in the map
    final route = indexRouteMap[index];
    if (route != null) {
      GoRouter.of(context).go(route);
    }
  }
}
