// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_design/widgets/empty/empty.dart';
import 'package:bazar_books_design/widgets/texts/texts.dart';
import 'package:bazar_books_widgetbook/widgetbook.container.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent emptyWidgetbooks() {
  return WidgetbookComponent(
    name: 'BazUiEmpty',
    useCases: [
      WidgetbookUseCase(
        name: 'Empty',
        builder: (context) {
          return BazUiWidgetbook(
              copyCode: '''
          BazUiElevatedButton.showModal<void>(
            context,
            child: Container(),
          )''',
              child: Column(
                children: [
                  Align(
                    child: BazUiRegularBodyText3(
                      text: 'Empty',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BazUiEmpty(
                    icon: Icons.info_outline,
                    message: 'Empty',
                    onPressed: () {},
                  ),
                ],
              ));
        },
      ),
    ],
  );
}
