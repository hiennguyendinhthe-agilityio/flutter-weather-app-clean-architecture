// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:bazar_books_design/widgets/buttons/buttons.dart';
import 'package:bazar_books_design/widgets/texts/texts.dart';
import 'package:bazar_books_widgetbook/widgetbook.container.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent buttonWidgetBooks() {
  return WidgetbookComponent(
    name: 'BazUiButton',
    useCases: [
      WidgetbookUseCase(
        name: 'Button',
        builder: (context) {
          final textKnobs = context.knobs.list(
            label: 'Buttons',
            options: [
              'Login',
              'Done',
            ],
          );

          return BazUiWidgetbook(
            copyCode: '''
       BazUiElevatedButton(
                        text: context.knobs.list(
                          label: 'Text Buttons',
                          options: [
                            'Confirm Freeze Card',
                            'Done',
                            'View New Card',
                            'Next',
                            'Continue',
                            'Use Face ID',
                            'Close my account',
                          ],
                        ),
                        onPressed: () => log('Tap on the Create Account button'),
                      ),''',
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const BazUiH3Text(
                    text: 'Elevated Button',
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const BazUiH5Text(
                    text: 'Regular',
                    color: Colors.black,
                  ),
                  BazUiElevatedButton(
                    text: textKnobs,
                    onPressed: () {
                      log('Button has been pressed');
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const BazUiH5Text(
                    text: 'Loading State',
                    color: Colors.black,
                  ),
                  BazUiElevatedButton(
                    text: textKnobs,
                    isLoading: true,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const BazUiH3Text(
                    text: 'Outlined Button',
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const BazUiH5Text(
                    text: 'Regular',
                    color: Colors.black,
                  ),
                  BazUiOutLinedButton(
                    text: textKnobs,
                    onPressed: () {
                      log('Button has been pressed');
                    },
                  ),
                  BazUiOutLinedButton(
                    text: textKnobs,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ],
  );
}
