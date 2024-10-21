import 'package:bazar_books_app/features/auth/sign_in.dart';
import 'package:bazar_books_app/features/cart/cart_screen.dart';
import 'package:bazar_books_app/features/category/category_screen.dart';
import 'package:bazar_books_app/features/home/home_page.dart';
import 'package:bazar_books_app/features/profile/profile_screen.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/widgets/images/image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/categories',
              builder: (context, state) => const CategoryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart',
              builder: (context, state) => const CartScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _getSelectedIndex(state.uri.toString()),
            onTap: (index) => _onItemTapped(context, index),
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
          ),
        );
      },
    ),
  ],
);

/// Returns the index of the bottom navigation bar item based on the given location.
///
/// The given location is expected to be a string representing a URI.
///
/// The mapping of location to index is as follows:
///   - '/categories' maps to 1
///   - '/cart' maps to 2
///   - '/profile' maps to 3
///   - All other locations map to 0
int _getSelectedIndex(String location) {
  if (location.startsWith('/categories')) return 1;
  if (location.startsWith('/cart')) return 2;
  if (location.startsWith('/profile')) return 3;
  return 0;
}

/// Navigates to the route based on the index selected in the bottom navigation bar.
///
/// Parameters:
///   - context: The build context of the widget.
///   - index: The index of the selected item in the bottom navigation bar.
void _onItemTapped(BuildContext context, int index) {
  final routes = ['/home', '/categories', '/cart', '/profile'];
  context.go(routes[index]);
}
