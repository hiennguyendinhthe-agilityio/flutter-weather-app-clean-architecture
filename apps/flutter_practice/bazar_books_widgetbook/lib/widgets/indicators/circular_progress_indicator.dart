// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_design/widgets/indicators/circular_progress_indicator.dart';
import 'package:bazar_books_design/widgets/texts/texts.dart';
import 'package:bazar_books_widgetbook/widgetbook.container.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent circularProgressIndicatorWidgetbooks() {
  return WidgetbookComponent(
    name: 'BazUiCircularProgressIndicator',
    useCases: [
      WidgetbookUseCase(
        name: 'CircularProgressIndicator',
        builder: (context) {
          return BazUiWidgetbook(
              copyCode: '''
       BazUiCircularProgressIndicator(
          
          )''',
              child: Column(
                children: [
                  Align(
                    child: BazUiRegularBodyText3(
                      text: 'CircularProgressIndicator',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const BazUiCircularProgressIndicator(),
                ],
              ));
        },
      ),
    ],
  );
}
