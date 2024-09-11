// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en_US locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en_US';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "errorEmailClient": MessageLookupByLibrary.simpleMessage(
            "There was a temporary problem launch email system. Please try again later."),
        "signInPageDontHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Don’t have an account?"),
        "signInPageEmail": MessageLookupByLibrary.simpleMessage("Email"),
        "signInPageForgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "signInPageLogin": MessageLookupByLibrary.simpleMessage("Login"),
        "signInPageOrWith": MessageLookupByLibrary.simpleMessage("Or with"),
        "signInPagePassword": MessageLookupByLibrary.simpleMessage("Password"),
        "signInPageSignUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "signInPageWelcomeBack":
            MessageLookupByLibrary.simpleMessage("Welcome Back 👋"),
        "signInPageWithApple":
            MessageLookupByLibrary.simpleMessage("Sign in with Apple"),
        "signInPageWithGoogle":
            MessageLookupByLibrary.simpleMessage("Sign in with Google"),
        "signInPageYourAccount":
            MessageLookupByLibrary.simpleMessage("Sign to your account"),
        "signInPageYourEmail":
            MessageLookupByLibrary.simpleMessage("Your email"),
        "signInPageYourPassword":
            MessageLookupByLibrary.simpleMessage("Your password")
      };
}
