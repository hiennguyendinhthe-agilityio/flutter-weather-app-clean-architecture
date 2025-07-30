import 'package:flutter/material.dart';
import 'package:flutter_auth_demo/core/di/injection.dart';
import 'package:flutter_auth_demo/core/exceptions/app_exceptions.dart';
import 'package:flutter_auth_demo/data/models/api_user.dart';
import 'package:flutter_auth_demo/data/services/auth_service.dart';
import 'package:flutter_auth_demo/main.dart';
import 'package:flutter_auth_demo/presentation/pages/home_page.dart';
import 'package:flutter_auth_demo/presentation/pages/login_page.dart';
import 'package:flutter_auth_demo/presentation/pages/signup_page.dart';
import 'package:flutter_auth_demo/presentation/providers/user_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

// Mock classes
class MockAuthService extends Mock implements AuthService {}

// Test data
const testUser = ApiUser(
  id: '1',
  name: 'Test User',
  email: 'testuser@example.com',
  avatar: '',
);

void main() {
  group('Authentication Flow Integration Tests', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();

      // Reset GetIt for testing
      if (getIt.isRegistered<AuthService>()) {
        getIt.unregister<AuthService>();
      }
      if (getIt.isRegistered<UserProvider>()) {
        getIt.unregister<UserProvider>();
      }

      // Register mocks
      getIt.registerSingleton<AuthService>(mockAuthService);
      getIt.registerSingleton<UserProvider>(UserProvider(mockAuthService));
    });

    tearDown(() {
      getIt.reset();
    });

    testWidgets('Login flow works correctly', (tester) async {
      // Setup mocks for successful login
      when(
        () => mockAuthService.hasValidSession(),
      ).thenAnswer((_) async => false);
      when(
        () => mockAuthService.login('testuser@example.com', 'password123'),
      ).thenAnswer((_) async => testUser);

      // Build the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => getIt<UserProvider>()..initialize(),
            ),
          ],
          child: MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (context) => const AuthWrapper(),
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignUpPage(),
              '/home': (context) => const HomePage(),
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should start on Login page
      expect(find.byKey(const Key('loginPage')), findsOneWidget);
      expect(find.text('Welcome Back'), findsOneWidget);

      // Fill login form
      await tester.enterText(
        find.byKey(const Key('emailField')),
        'testuser@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('passwordField')),
        'password123',
      );

      // Submit login form
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Should navigate to Home page
      expect(find.byKey(const Key('homePage')), findsOneWidget);
      expect(find.textContaining('Welcome'), findsOneWidget);

      // Verify mock calls
      verify(
        () => mockAuthService.login('testuser@example.com', 'password123'),
      ).called(1);
    });

    testWidgets('Login with invalid credentials shows error', (tester) async {
      // Setup mocks for failed login
      when(
        () => mockAuthService.hasValidSession(),
      ).thenAnswer((_) async => false);
      when(
        () => mockAuthService.login('invalid@example.com', 'wrongpassword'),
      ).thenThrow(const AuthException('No account found with this email'));

      // Build the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => getIt<UserProvider>()..initialize(),
            ),
          ],
          child: MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (context) => const AuthWrapper(),
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignUpPage(),
              '/home': (context) => const HomePage(),
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Fill login form with invalid credentials
      await tester.enterText(
        find.byKey(const Key('emailField')),
        'invalid@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('passwordField')),
        'wrongpassword',
      );

      // Submit login form
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Should show error message
      expect(find.text('No account found with this email'), findsOneWidget);

      // Should still be on Login page
      expect(find.byKey(const Key('loginPage')), findsOneWidget);

      // Verify mock call
      verify(
        () => mockAuthService.login('invalid@example.com', 'wrongpassword'),
      ).called(1);
    });

    testWidgets('Navigation between Login and SignUp works', (tester) async {
      // Setup mocks
      when(
        () => mockAuthService.hasValidSession(),
      ).thenAnswer((_) async => false);

      // Build the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => getIt<UserProvider>()..initialize(),
            ),
          ],
          child: MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (context) => const AuthWrapper(),
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignUpPage(),
              '/home': (context) => const HomePage(),
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Start on Login page
      expect(find.byKey(const Key('loginPage')), findsOneWidget);

      // Navigate to SignUp
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('signupPage')), findsOneWidget);

      // Navigate back to Login
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('loginPage')), findsOneWidget);
    });

    testWidgets('Form validation works on Login page', (tester) async {
      // Setup mocks
      when(
        () => mockAuthService.hasValidSession(),
      ).thenAnswer((_) async => false);

      // Build the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => getIt<UserProvider>()..initialize(),
            ),
          ],
          child: MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (context) => const AuthWrapper(),
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignUpPage(),
              '/home': (context) => const HomePage(),
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Test Login form validation - try to submit empty form
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('SignUp form validation works', (tester) async {
      // Setup mocks
      when(
        () => mockAuthService.hasValidSession(),
      ).thenAnswer((_) async => false);

      // Build the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => getIt<UserProvider>()..initialize(),
            ),
          ],
          child: MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (context) => const AuthWrapper(),
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignUpPage(),
              '/home': (context) => const HomePage(),
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to SignUp page
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Test SignUp form validation - try to submit empty form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('Authentication state persistence works correctly', (
      tester,
    ) async {
      // Setup mocks for existing session
      when(
        () => mockAuthService.hasValidSession(),
      ).thenAnswer((_) async => true);
      when(
        () => mockAuthService.getCurrentUser(),
      ).thenAnswer((_) async => testUser);

      // Build the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => getIt<UserProvider>()..initialize(),
            ),
          ],
          child: MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (context) => const AuthWrapper(),
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignUpPage(),
              '/home': (context) => const HomePage(),
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should directly navigate to Home page (user already authenticated)
      expect(find.byKey(const Key('homePage')), findsOneWidget);
      expect(find.textContaining('Welcome'), findsOneWidget);

      // Verify mock calls
      verify(() => mockAuthService.hasValidSession()).called(1);
      verify(() => mockAuthService.getCurrentUser()).called(1);
    });

    testWidgets('SignUp flow works correctly', (tester) async {
      // Setup mocks
      when(
        () => mockAuthService.hasValidSession(),
      ).thenAnswer((_) async => false);
      when(
        () => mockAuthService.signUp(
          'Test User',
          'testuser@example.com',
          'password123',
        ),
      ).thenAnswer((_) async => testUser);

      // Build the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => getIt<UserProvider>()..initialize(),
            ),
          ],
          child: MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (context) => const AuthWrapper(),
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignUpPage(),
              '/home': (context) => const HomePage(),
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to SignUp page
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Should be on SignUp page
      expect(find.byKey(const Key('signupPage')), findsOneWidget);

      // Fill signup form
      await tester.enterText(find.byKey(const Key('nameField')), 'Test User');
      await tester.enterText(
        find.byKey(const Key('emailField')),
        'testuser@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('passwordField')),
        'password123',
      );

      // Submit signup form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pumpAndSettle();

      // Wait for any pending timers (SignUpPage has a 2-second delay)
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Verify mock call - this is the main test objective
      verify(
        () => mockAuthService.signUp(
          'Test User',
          'testuser@example.com',
          'password123',
        ),
      ).called(1);
    });
  });
}
