// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_design/widgets/text_field/text_field.dart';
import 'package:bazar_books_design/widgets/texts/texts.dart';
import 'package:bazar_books_widgetbook/widgetbook.container.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent textFiledWidgetBooks() {
  return WidgetbookComponent(
    name: 'BazUiTextField',
    useCases: [
      WidgetbookUseCase(
        name: 'TextField',
        builder: (context) => BazUiWidgetbook(
          copyCode: 'BazUiTextField()',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BazUiRegularBodyText3(
                text: 'TextFiled Input',
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 20,
              ),
              BazUiTextField(
                labelText: 'Email',
                hintText: 'Your email',
                focusNode: FocusNode(),
              ),
              const SizedBox(
                height: 20,
              ),
              BazUiTextField(
                labelText: 'Password',
                hintText: 'Your password',
                focusNode: FocusNode(),
              )
            ],
          ),
        ),
      ),
    ],
  );
}
