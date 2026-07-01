class AppConstants {
  AppConstants._();

  // SharedPreferences keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserJson = 'user_json';

  // Timeouts
  static const Duration mockDelay = Duration(milliseconds: 800);

  // Validation
  static const int minPasswordLength = 6;

  // Responsive breakpoints
  static const double tabletBreakpoint = 600.0;
}
