part of 'app_pages.dart';

abstract class Routes {
  static const initial = _Paths.logIn;
  static const login = _Paths.logIn;
  static const applicationForm = _Paths.applicationForm;
  static const home = _Paths.home;
}

abstract class _Paths {
  static const logIn = '/login';
  static const applicationForm = '/application-form';
  static const home = '/home_initial_page';
}
