import 'package:bazar_books_app/di/di.dart';
import 'package:bazar_books_app/features/auth/blocs/auth_bloc.dart';
import 'package:bazar_books_app/features/auth/congratulation_screen.dart';
import 'package:bazar_books_app/features/auth/sign_in.dart';
import 'package:bazar_books_app/features/auth/sign_up.dart';
import 'package:bazar_books_app/features/cart/cart_screen.dart';
import 'package:bazar_books_app/features/category/categori_search/bloc/search_bloc.dart';
import 'package:bazar_books_app/features/category/data/category_repository.dart';
import 'package:bazar_books_app/features/category/screen/category_screen.dart';
import 'package:bazar_books_app/features/home/home_page.dart';
import 'package:bazar_books_app/features/home/widgets/author/author_profile/author_profile.dart';
import 'package:bazar_books_app/features/home/widgets/author/authors.dart';
import 'package:bazar_books_app/features/home/widgets/vendors/vendors.dart';
import 'package:bazar_books_app/features/notification/notification_page.dart';
import 'package:bazar_books_app/features/profile/profile_screen.dart';
import 'package:bazar_books_app/features/profile/screens/address_screen.dart';
import 'package:bazar_books_app/features/profile/screens/help_center_screen.dart';
import 'package:bazar_books_app/features/profile/screens/my_account_screen.dart';
import 'package:bazar_books_app/features/profile/screens/my_favorite_screen.dart';
import 'package:bazar_books_app/features/profile/screens/offers_and_promos_screen.dart';
import 'package:bazar_books_app/features/profile/screens/order_history_screen.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/category/categori_search/screen/search_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

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
      builder: (context, state) => const SignInScreen(),
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
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: const HomePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
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
            GoRoute(
              path: RoutePaths.notifications,
              builder: (BuildContext context, GoRouterState state) {
                return const NotificationsPage();
              },
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.authorProfile,
          builder: (BuildContext context, GoRouterState state) {
            final authorId = state.uri.queryParameters['authorId'] ?? "N/A";
            return AuthorProfile(authorId: authorId);
          },
        ),

        /// Displayed when the second item in the the bottom navigation bar is
        /// selected.
        GoRoute(
          path: RoutePaths.categories,
          builder: (BuildContext context, GoRouterState state) {
            return const CategoryScreen();
          },
          routes: [
            GoRoute(
              path: RoutePaths.search,
              builder: (BuildContext context, GoRouterState state) {
                return BlocProvider(
                  create: (BuildContext context) =>
                      SearchBloc(searchRepository: getIt<CategoryRepository>()),
                  child: const SearchScreen(),
                );
              },
            ),
          ],
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: const CategoryScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),

        /// The third screen to display in the bottom navigation bar.
        GoRoute(
          path: RoutePaths.cart,
          builder: (BuildContext context, GoRouterState state) {
            return const CartScreen();
          },
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: const CartScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: RoutePaths.profile,
          builder: (BuildContext context, GoRouterState state) {
            return const ProfileScreen();
          },
          routes: [
            GoRoute(
              path: RoutePaths.account,
              builder: (BuildContext context, GoRouterState state) {
                return const MyAccountScreen();
              },
            ),
            GoRoute(
              path: RoutePaths.myFavorites,
              builder: (BuildContext context, GoRouterState state) {
                final userId = (context.read<AuthBloc>().state as Authenticated)
                    .user
                    .userId;
                return MyFavorite(userId: userId ?? '');
              },
            ),
            GoRoute(
              path: RoutePaths.address,
              builder: (BuildContext context, GoRouterState state) {
                return const AddressScreen();
              },
            ),
            GoRoute(
              path: RoutePaths.offersAndPromos,
              builder: (BuildContext context, GoRouterState state) {
                return const OffersAndPromosScreen();
              },
            ),
            GoRoute(
              path: RoutePaths.orderHistory,
              builder: (BuildContext context, GoRouterState state) {
                final orderId = state.uri.queryParameters['orderId'];
                return OrderHistoryScreen(orderId: orderId);
              },
            ),
            GoRoute(
              path: RoutePaths.helpCenter,
              builder: (BuildContext context, GoRouterState state) {
                return const HelpCenterScreen();
              },
            ),
          ],
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: const ProfileScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          },
        ),
      ],
    ),
  ],
);
Future<String?> _guard(BuildContext context, GoRouterState state) async {
  final authBloc = BlocProvider.of<AuthBloc>(context);
  final isLoggedIn = await authBloc.authenticationRepository.isLoggedIn();

  if (!isLoggedIn &&
      state.uri.toString() != RoutePaths.signup &&
      state.uri.toString() != RoutePaths.congratulations) {
    return RoutePaths.login;
  }

  if (isLoggedIn && state.uri.toString() == RoutePaths.login) {
    return RoutePaths.home;
  }

  return null;
}
