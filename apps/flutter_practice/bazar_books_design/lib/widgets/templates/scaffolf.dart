import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A stateless widget that wraps the Material Scaffold widget and customizes
/// it with Agility Design specific configuration.
///
/// This widget is useful for creating pages in our application.
class BazUiScaffold extends StatelessWidget {
  /// Creates a [BazUiScaffold] widget.
  ///
  /// The [body] argument is required and represents the main body of the
  /// scaffold.
  ///
  /// The [canPop] argument is optional and defaults to `true`. If `false`,
  /// the app bar will not display a back button for the user to navigate
  /// back.
  ///
  /// The [appBar] argument is optional and defaults to `null`. If provided,
  /// this widget will be used as the app bar for this page.
  ///
  /// The [fabButtonDebugStories] argument is optional and defaults to `null`.
  /// If provided, this widget will be displayed as the floating action button
  /// in debug mode.
  ///
  /// The [mainNavigation] argument is optional and defaults to `null`. If
  /// provided, this widget will be displayed at the bottom of the page.
  ///
  /// The [backgroundColor] argument is optional and defaults to `null`. If
  /// provided, this value will be used as the background color for the page.
  /// If not provided, the background color will be determined by the current
  /// theme's background color.
  const BazUiScaffold({
    required this.body,
    this.canPop = true,
    this.appBar,
    this.fabButtonDebugStories,
    this.mainNavigation,
    this.backgroundColor,
    super.key,
  });

  /// The main body of the scaffold.
  final Widget body;

  /// The app bar for this page.
  final PreferredSizeWidget? appBar;

  /// The floating action button for debug mode.
  final Widget? fabButtonDebugStories;

  /// The navigation bar for this page.
  final Widget? mainNavigation;

  /// The background color for this page.
  final Color? backgroundColor;

  /// If `false`, the app bar will not display a back button for the user to
  /// navigate back.
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    final color = backgroundColor ?? context.colorScheme.surfaceContainerLowest;
    final colorComputeLuminance = color.computeLuminance();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            colorComputeLuminance >= 0.5 ? Brightness.dark : Brightness.light,
      ),
      child: PopScope(
        canPop: canPop,
        child: Scaffold(
          appBar: appBar,
          backgroundColor: backgroundColor ?? context.colorScheme.onPrimary,
          body: body,
          bottomNavigationBar: mainNavigation,
          floatingActionButton: fabButtonDebugStories,
          resizeToAvoidBottomInset: true,
        ),
      ),
    );
  }
}
