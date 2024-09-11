// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class BazUiS {
  BazUiS();

  static BazUiS? _current;

  static BazUiS get current {
    assert(_current != null,
        'No instance of BazUiS was loaded. Try to initialize the BazUiS delegate before accessing BazUiS.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<BazUiS> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = BazUiS();
      BazUiS._current = instance;

      return instance;
    });
  }

  static BazUiS of(BuildContext context) {
    final instance = BazUiS.maybeOf(context);
    assert(instance != null,
        'No instance of BazUiS present in the widget tree. Did you add BazUiS.delegate in localizationsDelegates?');
    return instance!;
  }

  static BazUiS? maybeOf(BuildContext context) {
    return Localizations.of<BazUiS>(context, BazUiS);
  }

  /// `There was a temporary problem launch email system. Please try again later.`
  String get errorEmailClient {
    return Intl.message(
      'There was a temporary problem launch email system. Please try again later.',
      name: 'errorEmailClient',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back 👋`
  String get signInPageWelcomeBack {
    return Intl.message(
      'Welcome Back 👋',
      name: 'signInPageWelcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get signInPageLogin {
    return Intl.message(
      'Login',
      name: 'signInPageLogin',
      desc: '',
      args: [],
    );
  }

  /// `Sign to your account`
  String get signInPageYourAccount {
    return Intl.message(
      'Sign to your account',
      name: 'signInPageYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get signInPageEmail {
    return Intl.message(
      'Email',
      name: 'signInPageEmail',
      desc: '',
      args: [],
    );
  }

  /// `Your email`
  String get signInPageYourEmail {
    return Intl.message(
      'Your email',
      name: 'signInPageYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get signInPagePassword {
    return Intl.message(
      'Password',
      name: 'signInPagePassword',
      desc: '',
      args: [],
    );
  }

  /// `Your password`
  String get signInPageYourPassword {
    return Intl.message(
      'Your password',
      name: 'signInPageYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get signInPageForgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'signInPageForgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Or with`
  String get signInPageOrWith {
    return Intl.message(
      'Or with',
      name: 'signInPageOrWith',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get signInPageWithGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'signInPageWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Apple`
  String get signInPageWithApple {
    return Intl.message(
      'Sign in with Apple',
      name: 'signInPageWithApple',
      desc: '',
      args: [],
    );
  }

  /// `Don’t have an account?`
  String get signInPageDontHaveAnAccount {
    return Intl.message(
      'Don’t have an account?',
      name: 'signInPageDontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signInPageSignUp {
    return Intl.message(
      'Sign Up',
      name: 'signInPageSignUp',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<BazUiS> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<BazUiS> load(Locale locale) => BazUiS.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
