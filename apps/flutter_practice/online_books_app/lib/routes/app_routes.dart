import 'package:online_books_app/presentation/audio_books/list_audio_books_screen.dart';
import 'package:online_books_app/presentation/auth/login/login_screen.dart';
import 'package:online_books_app/presentation/auth/signup/signup_screen.dart';
import 'package:online_books_app/presentation/e_books/list_ebooks_screen.dart';
import 'package:online_books_app/presentation/home/binding/home_binding.dart';
import 'package:online_books_app/presentation/home/home_screen.dart';
import 'package:online_books_app/presentation/notification/notification_screen.dart';
import 'package:online_books_app/presentation/onboarding/onboardingone_screen/binding/onboardingone_binding.dart';
import 'package:online_books_app/presentation/onboarding/onboardingone_screen/onboardingone_screen.dart';
import 'package:online_books_app/presentation/onboarding/onboardingthree_screen/binding/onboardingthree_binding.dart';
import 'package:online_books_app/presentation/onboarding/onboardingthree_screen/onboardingthree_screen.dart';
import 'package:online_books_app/presentation/onboarding/onboardingtwo_screen/binding/onboardingtwo_binding.dart';
import 'package:online_books_app/presentation/onboarding/onboardingtwo_screen/onboardingtwo_screen.dart';

import '../core/app_export.dart';

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String onboardingoneScreen = '/onboardingone_screen';
  static const String onboardingtwoScreen = '/onboardingtwo_screen';
  static const String onboardingthreeScreen = '/onboardingthree_screen';
  static const String signupScreen = '/signup_screen';
  static const String loginScreen = '/login_screen';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/initialRoute';
  static const String homeInitialPage = '/home_initial_page';
  static const String homeScreen = '/home_screen';
  static const String savedScreen = '/saved_page';
  static const String profilePage = '/profile_page';
  static const String settingsPage = '/settings_page';

  static const String itemListEbook = '/item_list_ebook';

  static const String readBookScreen = '/read_book_screen';

  static const String listAudioBook = '/item_list_audio_book';

  static const String notificationScreen = '/notification_screen';

  static List<GetPage> pages = [
    GetPage(name: notificationScreen, page: () => NotificationScreen()),
    GetPage(
      name: listAudioBook,
      page: () => ListAudioBooksScreen(),
    ),
    GetPage(
      name: itemListEbook,
      page: () => ListEbooksScreen(),
    ),
    GetPage(
      name: onboardingoneScreen,
      page: () => OnboardingoneScreen(),
      bindings: [OnboardingoneBinding()],
    ),
    GetPage(
      name: onboardingtwoScreen,
      page: () => OnboardingtwoScreen(),
      bindings: [OnboardingtwoBinding()],
    ),
    GetPage(
      name: onboardingthreeScreen,
      page: () => OnboardingthreeScreen(),
      bindings: [OnboardingthreeBinding()],
    ),
    GetPage(
      name: signupScreen,
      page: () => SignupScreen(),
    ),
    GetPage(
      name: loginScreen,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: initialRoute,
      page: () => OnboardingoneScreen(),
      bindings: [OnboardingoneBinding()],
    ),
    GetPage(
        name: homeInitialPage,
        page: () => HomeScreen(),
        bindings: [HomeBinding()]),
  ];
}
