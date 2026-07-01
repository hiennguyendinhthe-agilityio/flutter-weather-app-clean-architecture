import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/banking_app/features/auth/screens/login_screen.dart';
import 'package:flutter_advanced_course/banking_app/features/auth/screens/register_screen.dart';
import 'package:flutter_advanced_course/banking_app/features/home/screens/home_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return _fadeRoute(const LoginScreen(), settings);
      case AppRoutes.register:
        return _slideRoute(const RegisterScreen(), settings);
      case AppRoutes.home:
        return _slideUpRoute(const HomeScreen(), settings);
      default:
        return _fadeRoute(const LoginScreen(), settings);
    }
  }

  // Fade transition
  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, anim, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
        child: child,
      ),
    );
  }

  // Slide from right
  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, anim, _, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: child,
      ),
    );
  }

  // Slide from bottom (for main home)
  static PageRouteBuilder _slideUpRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, anim, secondary, child) {
        // New screen slides up + fades in
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));

        final fade = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: anim, curve: const Interval(0, 0.6)));

        return SlideTransition(
          position: slide,
          child: FadeTransition(opacity: fade, child: child),
        );
      },
    );
  }
}
