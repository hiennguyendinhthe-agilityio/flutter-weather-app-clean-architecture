// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_app/features/auth/presentation/sign_in.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent loginScreenWidgetbooks() {
  return WidgetbookComponent(
    name: 'LoginScreen',
    useCases: [
      WidgetbookUseCase(
        name: 'LoginScreen',
        builder: (context) {
          return const LoginScreen();
        },
      ),
    ],
  );
}
