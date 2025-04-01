// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_app/features/home/home_page.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent homePageWidgetbooks() {
  return WidgetbookComponent(
    name: 'HomePage',
    useCases: [
      WidgetbookUseCase(
        name: 'HomePage',
        builder: (context) {
          return const HomePage();
        },
      ),
    ],
  );
}
