// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_design/widgets/images/image.dart';
import 'package:bazar_books_design/widgets/texts/texts.dart';
import 'package:bazar_books_widgetbook/widgetbook.container.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent iconsWidgetBooks() {
  return WidgetbookComponent(
    name: 'Icons',
    useCases: [
      WidgetbookUseCase(
        name: 'All Icons',
        builder: (context) => Scaffold(
          body: BazUiWidgetbook(
            boxShadow: const [
              BoxShadow(),
            ],
            copyCode: '''
     _IconWidgetbookItem(
                    name: 'Check circle',
                    builder: (context) =>
                        BazUiBuiltInImage.icCheckCircleSmall(),
                  ),
                  _IconWidgetbookItem(
                    name: 'Paid',
                    builder: (context) => BazUiBuiltInImage.icPaid(),
                  ),
                  _IconWidgetbookItem(
                    name: 'Progress circle',
                    builder: (context) =>
                        BazUiBuiltInImage.icProgressBarCircle(),
                  ),''',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        blurRadius: 1,
                        offset: const Offset(1, 1), // Shadow position
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 15, top: 20),
                                child: BazUiBodyText1(
                                  textAlign: TextAlign.left,
                                  text: 'Iconography',
                                ),
                              ),
                              GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 6,
                                children: [
                                  _IconWidgetbookItem(
                                    builder: (context) =>
                                        BazUiBuiltInImage.icHomeFill(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                  _IconWidgetbookItem(
                                    builder: (context) =>
                                        BazUiBuiltInImage.icArrowLeft(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                  _IconWidgetbookItem(
                                    builder: (context) =>
                                        BazUiBuiltInImage.icBellOutline(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                  _IconWidgetbookItem(
                                    builder: (context) =>
                                        BazUiBuiltInImage.icMenuFill(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                  _IconWidgetbookItem(
                                    builder: (context) =>
                                        BazUiBuiltInImage.icCardFill(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                  _IconWidgetbookItem(
                                    builder: (context) =>
                                        BazUiBuiltInImage.icProfileFill(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                  _IconWidgetbookItem(
                                    builder: (context) =>
                                        BazUiBuiltInImage.icBellOutline(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                  _IconWidgetbookItem(
                                    builder: (context) =>
                                        BazUiBuiltInImage.icSearch(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                  _IconWidgetbookItem(
                                    builder: (context) =>
                                        BazUiBuiltInImage.icArrowLeft(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                  _IconWidgetbookItem(
                                    builder: (context) =>
                                        BazUiBuiltInImage.icPassword(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                  _IconWidgetbookItem(
                                    builder: (context) =>
                                        BazUiBuiltInImage.icUnPassword(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                  _IconWidgetbookItem(
                                    builder: (context) =>
                                        BazUiBuiltInImage.icAdd(),
                                  ),
                                  _IconWidgetbookItem(
                                    builder: (context) =>
                                        BazUiBuiltInImage.icLess(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                  _IconWidgetbookItem(
                                    builder: (context) =>
                                        BazUiBuiltInImage.icLoveFill(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                  _IconWidgetbookItem(
                                    builder: (context) =>
                                        BazUiBuiltInImage.icStar(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

class _IconWidgetbookItem extends StatelessWidget {
  const _IconWidgetbookItem({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(BuildContext) builder;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 25,
        height: 50,
        child: builder(context),
      ),
    );
  }
}
