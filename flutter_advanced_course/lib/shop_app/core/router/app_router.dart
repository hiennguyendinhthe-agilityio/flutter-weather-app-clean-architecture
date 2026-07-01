import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/shop_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_advanced_course/shop_app/features/auth/screens/login_screen.dart';
import 'package:flutter_advanced_course/shop_app/features/cart/screens/cart_screen.dart';
import 'package:flutter_advanced_course/shop_app/features/home/screens/home_screen.dart';
import 'package:flutter_advanced_course/shop_app/features/product/screens/product_detail_screen.dart';
import 'package:flutter_advanced_course/shop_app/features/product/screens/product_list_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ValueNotifier<AuthUser?>(ref.read(authProvider));
  ref.listen(authProvider, (_, next) {
    authNotifier.value = next;
  });

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isLoggedIn = authNotifier.value != null;
      final isLoginPage = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginPage) return '/login';

      if (isLoggedIn && isLoginPage) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductListScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final productId = state.pathParameters['id']!;
              return ProductDetailScreen(productId: productId);
            },
          ),
        ],
      ),
      GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
    ],
  );
});
