// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_design/core/resources/l10n_generated/l10n.dart';
import 'package:bazar_books_design/themes/light_theme.dart';
import 'package:bazar_books_widgetbook/themes/colors.widgetbooks.dart';
import 'package:bazar_books_widgetbook/themes/icon.widgetbooks.dart';
import 'package:bazar_books_widgetbook/widgets/buttons/button_widgetbooks.dart';
import 'package:bazar_books_widgetbook/widgets/cards/cards_widgetbooks.dart';
import 'package:bazar_books_widgetbook/widgets/text_field/text_field_widgetbooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

Future<void> main() async {
  runApp(
    const BazUiBankingDesignWidgetbooks(),
  );
}

///
/// The bootstrap widgetbook application.
/// Refer docs/widgetbook.md for detail.
///
@widgetbook.App()
class BazUiBankingDesignWidgetbooks extends StatelessWidget {
  const BazUiBankingDesignWidgetbooks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      appBuilder: (context, child) => ResponsiveWrapper.builder(
        CupertinoScaffold(
          transitionBackgroundColor: Colors.transparent,
          body: child,
        ),
        maxWidth: 800,
        minWidth: 375,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(480, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
        ],
      ),
      addons: [
        LocalizationAddon(
          locales: [
            ...BazUiS.delegate.supportedLocales,
            const Locale('en', 'US'),
          ],
          initialLocale: const Locale('en', 'US'),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            BazUiS.delegate,
          ],
        ),
        DeviceFrameAddon(
          devices: [
            ...Devices.all,
          ],
          initialDevice: Devices.ios.iPhone13ProMax,
        ),
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: bazUiLightTheme,
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: bazUiDarkTheme,
            ),
          ],
        ),
      ],
      directories: [
        WidgetbookCategory(
          name: 'Design',
          children: [
            colorsWidgetBooks(),
            iconsWidgetBooks(),
          ],
        ),
        WidgetbookCategory(
          name: 'Widgets',
          children: [
            WidgetbookCategory(
              name: 'Buttons',
              children: [
                buttonWidgetBooks(),
                textFiledWidgetBooks(),
                cardWidgetBooks(),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
