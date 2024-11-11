import 'package:bazar_books_app/features/auth/blocs/auth_bloc.dart';
import 'package:bazar_books_app/features/auth/congratulation_screen.dart';
import 'package:bazar_books_app/features/auth/sign_in.dart';
import 'package:bazar_books_app/features/auth/sign_up_screen.dart';
import 'package:bazar_books_app/features/cart/cart_screen.dart';
import 'package:bazar_books_app/features/category/category_screen.dart';
import 'package:bazar_books_app/features/home/home_page.dart';
import 'package:bazar_books_app/features/home/widgets/author/authors.dart';
import 'package:bazar_books_app/features/home/widgets/vendors/vendors.dart';
import 'package:bazar_books_app/features/profile/profile_screen.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');
Future<String?> _guard(BuildContext context, GoRouterState state) async {
  final authBloc = BlocProvider.of<AuthBloc>(context);
  final isLoggedIn = await authBloc.authenticationRepository.isLoggedIn();

  if (!isLoggedIn && state.uri.toString() != RoutePaths.signup) {
    return RoutePaths.login;
  }

  if (isLoggedIn && state.uri.toString() == RoutePaths.login) {
    return RoutePaths.home;
  }

  return null;
}

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  errorBuilder: (BuildContext context, GoRouterState state) => Error(
    state.error!,
  ),
  initialLocation: RoutePaths.login,
  redirect: _guard,
  routes: [
    GoRoute(
      path: RoutePaths.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RoutePaths.signup,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: RoutePaths.congratulations,
      builder: (context, state) => const CongratulationsScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        final showBottomNavBar = state.uri.toString() == RoutePaths.home ||
            state.uri.toString() == RoutePaths.categories ||
            state.uri.toString() == RoutePaths.cart ||
            state.uri.toString() == RoutePaths.profile;
        return MainNavigation(
          showBottomNavBar: showBottomNavBar,
          child: child,
        );
      },
      routes: <RouteBase>[
        /// The first screen to display in the bottom navigation bar.
        GoRoute(
          path: RoutePaths.home,
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
          routes: [
            GoRoute(
              path: RoutePaths.vendors,
              builder: (BuildContext context, GoRouterState state) {
                return const Vendors();
              },
            ),
            GoRoute(
              path: RoutePaths.authors,
              builder: (BuildContext context, GoRouterState state) {
                return const Authors();
              },
            ),
          ],
        ),

        /// Displayed when the second item in the the bottom navigation bar is
        /// selected.
        GoRoute(
          path: RoutePaths.categories,
          builder: (BuildContext context, GoRouterState state) {
            return const CategoryScreen();
          },
        ),

        /// The third screen to display in the bottom navigation bar.
        GoRoute(
          path: RoutePaths.cart,
          builder: (BuildContext context, GoRouterState state) {
            return const CartScreen();
          },
        ),
        GoRoute(
          path: RoutePaths.profile,
          builder: (BuildContext context, GoRouterState state) {
            return const ProfileScreen();
          },
        ),
      ],
    ),
  ],
);
