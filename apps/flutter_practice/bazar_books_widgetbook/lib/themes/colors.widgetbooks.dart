// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_design/themes/light_theme.dart';
import 'package:bazar_books_design/widgets/texts/texts.dart';
import 'package:bazar_books_widgetbook/widgetbook.container.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent colorsWidgetBooks() {
  return WidgetbookComponent(
    name: 'Colors',
    useCases: [
      WidgetbookUseCase(
        name: 'Light mode',
        builder: (context) => BazUiWidgetbook(
          copyCode: '''
 _ColorItem(
                    name: 'primary',
                    color: schema.primary,
                  ),''',
          child: _ColorsSchemaWidget(
            nameTheme: 'Color of light theme',
            schema: bazUiLightTheme.colorScheme,
          ),
        ),
      ),
    ],
  );
}

class _ColorsSchemaWidget extends StatelessWidget {
  const _ColorsSchemaWidget({
    Key? key,
    required this.nameTheme,
    required this.schema,
  }) : super(key: key);

  /// Name of theme
  final String nameTheme;

  /// Schema color of theme
  final ColorScheme schema;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            BazUiBodyText1(
              text: nameTheme,
            ),
            const SizedBox(
              height: 10,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                _ColorItem(
                  name: 'primary',
                  color: schema.primary,
                ),
                _ColorItem(
                  name: 'onPrimary',
                  color: schema.onPrimary,
                ),
                _ColorItem(
                  name: 'secondary',
                  color: schema.secondary,
                ),
                _ColorItem(
                  name: 'onSecondary',
                  color: schema.onSecondary,
                ),
                _ColorItem(
                  name: 'surface',
                  color: schema.surface,
                ),
                _ColorItem(
                  name: 'onSurface',
                  color: schema.onSurface,
                ),
                _ColorItem(
                  name: 'surfaceContainerLowest',
                  color: schema.surfaceContainerLowest,
                ),
                _ColorItem(
                  name: 'error',
                  color: schema.error,
                ),
                _ColorItem(
                  name: 'onError',
                  color: schema.onError,
                ),
                _ColorItem(
                  name: 'inverseSurface',
                  color: schema.inverseSurface,
                ),
                _ColorItem(
                  name: 'onInverseSurface',
                  color: schema.onInverseSurface,
                ),
                _ColorItem(
                  name: 'onTertiary',
                  color: schema.onTertiary,
                ),
                _ColorItem(
                  name: 'onSurfaceVariant',
                  color: schema.onSurfaceVariant,
                ),
                _ColorItem(
                  name: 'primaryContainer',
                  color: schema.primaryContainer,
                ),
                _ColorItem(
                  name: 'onPrimaryContainer',
                  color: schema.onPrimaryContainer,
                ),
                _ColorItem(
                  name: 'surfaceTint',
                  color: schema.surfaceTint,
                ),
                _ColorItem(
                  name: 'onTertiaryContainer',
                  color: schema.onTertiaryContainer,
                ),
                _ColorItem(
                  name: 'outline',
                  color: schema.outline,
                ),
                _ColorItem(
                  name: 'shadow',
                  color: schema.shadow,
                ),
              ].map(_buildColorItem).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorItem {
  _ColorItem({
    required this.name,
    required this.color,
  });

  final String name;
  final Color color;
}

Widget _buildColorItem(_ColorItem item) {
  final boxStyle = Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      color: item.color,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          blurRadius: 4,
          offset: const Offset(4, 8),
          color: Colors.grey.withOpacity(0.5),
        ),
      ],
    ),
  );

  const textStyle = TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  return Container(
    padding: const EdgeInsets.all(
      10,
    ),
    child: Column(
      children: [
        boxStyle,
        const SizedBox(height: 5),
        Text(
          item.name,
          style: textStyle,
        ),
        const SizedBox(height: 3),
        Text(
          item.color.toString(),
          style: textStyle,
        ),
      ],
    ),
  );
}
