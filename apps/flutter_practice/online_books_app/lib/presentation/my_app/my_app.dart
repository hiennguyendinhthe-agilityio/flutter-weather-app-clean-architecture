import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/theme/theme_helper.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/localization/app_localization.dart';
import 'package:online_books_app/localization/l10n/app_localizations.dart';
import 'package:online_books_app/presentation/e_books/controller/author_controller.dart';
import 'package:online_books_app/presentation/e_books/list_ebooks_screen.dart';
import 'package:online_books_app/presentation/notification/controller/notification_controller.dart';
import 'package:online_books_app/routes/app_routes.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  final AuthorBooksController _bookController =
      Get.put(AuthorBooksController());
  bool _isInitialized = false;
  String _initialRoute = AppRoutes.onboardingoneScreen;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    final isOnboardingCompleted =
        prefs.getBool('onboarding_completed') ?? false;

    if (mounted) {
      setState(() {
        _initialRoute = isOnboardingCompleted
            ? AppRoutes.loginScreen
            : AppRoutes.onboardingoneScreen;
        _isInitialized = true;
      });
    }

    initDeepLinks();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle app start from deep link
    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null) {
      _handleDeepLink(appLink);
    }

    // Handle app opened from deep link
    _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  // Update the _handleDeepLink method to use the parser
  void _handleDeepLink(Uri uri) {
    debugPrint('Deep link received: $uri');

    final bookId = DeepLinkParser.extractBookId(uri);

    if (DeepLinkParser.isValidBookId(bookId)) {
      debugPrint('Valid book ID extracted: $bookId');
      // Ensure books are loaded before navigating
      _bookController.fetchBooks().then((_) {
        Get.toNamed(AppRoutes.eBookDetail, arguments: bookId);
      });
    } else {
      debugPrint('No valid book ID found in deep link: $uri');
      Get.snackbar(
        'Invalid Link',
        'The link you followed does not contain a valid book reference.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Sizer(
      builder: (context, orientation, deviceType) {
        return ResponsiveBreakpoints.builder(
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
          child: GetMaterialApp(
            initialBinding: BindingsBuilder(() {
              Get.put(NotificationController());
            }),
            unknownRoute: GetPage(
              name: '/item_list_ebook',
              page: () => ListEbooksScreen(),
            ),
            debugShowCheckedModeBanner: false,
            translations: AppLocalization(),
            locale: _getDefaultLocale(),
            fallbackLocale: const Locale('en', 'US'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            title: 'Online Books App',
            initialRoute: _initialRoute,
            getPages: AppRoutes.pages,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child ?? const SizedBox.shrink(),
              );
            },
            theme: theme,
          ),
        );
      },
    );
  }

  /// Get the default locale based on platform and user preferences
  Locale _getDefaultLocale() {
    // Get the device locale
    final deviceLocale = Get.deviceLocale;

    // Check if the device locale is supported
    if (deviceLocale != null) {
      final isSupported = AppLocalizations.supportedLocales.any(
        (locale) => locale.languageCode == deviceLocale.languageCode,
      );

      if (isSupported) {
        return deviceLocale;
      }
    }

    // Return English as default if device locale is not supported
    return const Locale('en', 'US');
  }
}

class DeepLinkParser {
  /// Extracts a book ID from a deep link URI
  static String? extractBookId(Uri uri) {
    try {
      // Handle web links (https://online-books-app.web.app/share/...)
      if (uri.host == 'online-books-app.web.app' &&
          uri.path.startsWith('/share')) {
        return uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
      }
      // Handle custom scheme (yourapp://book/...)
      else if (uri.scheme == 'yourapp' && uri.host == 'book') {
        // Handle both path-based and query parameter formats
        if (uri.pathSegments.isNotEmpty) {
          return uri.pathSegments[0];
        } else if (uri.queryParameters.containsKey('id')) {
          return uri.queryParameters['id'];
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error parsing deep link: $e');
      return null;
    }
  }

  /// Validates if a book ID is in the correct format
  static bool isValidBookId(String? bookId) {
    if (bookId == null || bookId.isEmpty) {
      return false;
    }

    // Add any additional validation logic here
    // For example, if book IDs should be numeric:
    // return int.tryParse(bookId) != null;

    return true;
  }

  /// Creates a shareable deep link for a book
  static String createBookShareLink(String bookId) {
    return 'https://online-books-app.web.app/share/$bookId';
  }

  /// Creates an App Direct deep link for a book
  static String createAppDirectLink(String bookId) {
    return 'yourapp://book?id=$bookId';
  }

  /// Creates both web and app direct share links
  static Map<String, String> createShareLinks(String bookId) {
    return {
      'web': createBookShareLink(bookId),
      'app_direct': createAppDirectLink(bookId),
    };
  }
}
