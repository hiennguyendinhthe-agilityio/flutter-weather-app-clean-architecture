import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_project/providers/counter_provider.dart';
import 'package:new_project/providers/user_provider.dart';
import 'package:new_project/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../mocks/mock_services.dart';

/// Test helpers for common testing scenarios
class TestHelpers {
  /// Create a test widget with providers
  static Widget createTestWidget({
    required Widget child,
    UserProvider? userProvider,
    CounterProvider? counterProvider,
  }) {
    return MultiProvider(
      providers: [
        if (userProvider != null)
          ChangeNotifierProvider<UserProvider>.value(value: userProvider),
        if (counterProvider != null)
          ChangeNotifierProvider<CounterProvider>.value(value: counterProvider),
      ],
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  /// Create a mock UserProvider for testing
  static UserProvider createMockUserProvider() {
    final mockUserService = MockSetupHelper.setupMockUserService();
    final mockUserApiService = MockSetupHelper.setupMockUserApiService();
    final mockLoggerService = MockSetupHelper.setupMockLogger();
    final mockAuthService = MockAuthService();

    return UserProvider(
      mockUserService,
      mockAuthService,
      mockUserApiService,
      mockLoggerService,
    );
  }

  /// Create a mock CounterProvider for testing
  static CounterProvider createMockCounterProvider() {
    final mockLoggerService = MockSetupHelper.setupMockLogger();
    return CounterProvider(mockLoggerService);
  }

  /// Pump and settle with custom duration
  static Future<void> pumpAndSettleWithDelay(
    WidgetTester tester, {
    Duration delay = const Duration(milliseconds: 100),
  }) async {
    await tester.pump(delay);
    await tester.pumpAndSettle();
  }

  /// Find widget by text with case insensitive search
  static Finder findTextIgnoreCase(String text) {
    return find.byWidgetPredicate((widget) {
      if (widget is Text) {
        return widget.data?.toLowerCase().contains(text.toLowerCase()) ?? false;
      }
      return false;
    });
  }

  /// Find button by text
  static Finder findButtonByText(String text) {
    return find.widgetWithText(ElevatedButton, text);
  }

  /// Find text field by label
  static Finder findTextFieldByLabel(String label) {
    return find.widgetWithText(TextField, label);
  }

  /// Enter text in text field
  static Future<void> enterTextInField(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Tap button and wait for animation
  static Future<void> tapAndWait(
    WidgetTester tester,
    Finder finder, {
    Duration delay = const Duration(milliseconds: 300),
  }) async {
    await tester.tap(finder);
    await tester.pump(delay);
    await tester.pumpAndSettle();
  }

  /// Verify loading indicator is shown
  static void expectLoadingIndicator() {
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }

  /// Verify loading indicator is not shown
  static void expectNoLoadingIndicator() {
    expect(find.byType(CircularProgressIndicator), findsNothing);
  }

  /// Verify error message is shown
  static void expectErrorMessage(String message) {
    expect(find.text(message), findsOneWidget);
  }

  /// Verify success message is shown
  static void expectSuccessMessage(String message) {
    expect(find.text(message), findsOneWidget);
  }

  /// Create test data for API responses
  static Map<String, dynamic> createTestUserJson({
    String id = '1',
    String name = 'Test User',
    String email = 'test@example.com',
    String? avatar,
    String? phone,
    String? address,
  }) {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (avatar != null) 'avatar': avatar,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      'created_at': '2024-01-01T00:00:00Z',
      'updated_at': '2024-01-01T00:00:00Z',
    };
  }

  /// Create list of test users
  static List<Map<String, dynamic>> createTestUsersList({int count = 3}) {
    return List.generate(
      count,
      (index) => createTestUserJson(
        id: '${index + 1}',
        name: 'Test User ${index + 1}',
        email: 'test${index + 1}@example.com',
      ),
    );
  }

  /// Verify widget exists and is visible
  static void expectWidgetVisible(Finder finder) {
    expect(finder, findsOneWidget);
    final widget = finder.evaluate().first.widget;
    expect(widget, isNotNull);
  }

  /// Verify widget does not exist
  static void expectWidgetNotFound(Finder finder) {
    expect(finder, findsNothing);
  }

  /// Verify text contains substring
  static void expectTextContains(String text, String substring) {
    final finder = find.byWidgetPredicate((widget) {
      if (widget is Text) {
        return widget.data?.contains(substring) ?? false;
      }
      return false;
    });
    expect(finder, findsAtLeastNWidgets(1));
  }

  /// Wait for async operations to complete
  static Future<void> waitForAsync({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Create test theme data
  static ThemeData createTestTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    );
  }

  /// Verify form validation
  static void expectFormValidationError(String errorMessage) {
    expect(find.text(errorMessage), findsOneWidget);
  }

  /// Verify no form validation errors
  static void expectNoFormValidationErrors() {
    // Common validation error patterns
    final errorPatterns = [
      'không được để trống',
      'không hợp lệ',
      'quá ngắn',
      'quá dài',
      'không đúng định dạng',
    ];

    for (final pattern in errorPatterns) {
      expect(find.textContaining(pattern), findsNothing);
    }
  }
}

/// Mock AuthService for testing
class MockAuthService extends Mock implements AuthService {}
