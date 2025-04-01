import 'package:bazar_books_design/core/constant/route_constants.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The screen of the error page.
class Error extends StatelessWidget {
  /// Creates an [Error].
  const Error(this.error, {super.key});

  /// The error to display.
  final Exception error;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(context.bazS.errorRoute)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SelectableText(error.toString()),
              TextButton(
                onPressed: () => context.go(RoutePaths.login),
                child: Text(context.bazS.signInPageLogin),
              ),
            ],
          ),
        ),
      );
}
