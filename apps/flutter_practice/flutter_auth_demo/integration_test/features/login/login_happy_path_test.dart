import 'package:flutter/material.dart';
import 'package:flutter_auth_demo/core/di/injection.dart';
import 'package:flutter_auth_demo/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest('logs in successfully on valid credentials', ($) async {
    // 1. Initialize dependencies.
    // This is a crucial step to ensure that all services and providers
    // (like UserProvider) are registered with GetIt before the app runs.
    await configureDependencies();

    // 2. Pump the app and wait for it to settle.
    // We assume your app's entry point is `MyApp` in `lib/main.dart`
    // and it sets up the necessary Providers.
    await $.pumpWidgetAndSettle(const app.MyApp());

    // 3. Verify that the login page is currently visible.
    // We use the key you defined on the Scaffold.
    await $(#loginPage).waitUntilVisible();

    // 4. Find the email and password fields and enter text.
    // Replace with credentials that are valid for your test environment.
    await $(#emailField).enterText('test@example.com');
    await $(#passwordField).enterText('password123');

    // 5. Tap the sign-in button.
    await $(#signInButton).tap();

    // 6. Wait for all asynchronous actions to complete, like the login
    // network request and the UI update from the AuthWrapper.
    await $.pumpAndSettle();

    // 7. Assert the outcome.
    // After a successful login, the AuthWrapper should navigate away
    // from the LoginPage. We verify the login page is no longer visible.
    expect($(#loginPage).visible, isFalse);

    // As a final check, we verify that the home page (or dashboard) is now visible.
    // IMPORTANT: Replace 'homePage' with the actual key of your post-login page.
    await $(const Key('homePage')).waitUntilVisible();
  });
}
