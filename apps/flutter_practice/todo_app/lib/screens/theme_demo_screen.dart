import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/theme_extensions.dart';
import '../constants/app_constants.dart';

/// Demo screen showcasing the comprehensive theme system
class ThemeDemoScreen extends StatelessWidget {
  const ThemeDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: context.backgroundColor,
      navigationBar: CupertinoNavigationBar(
        middle: ThemedText(
          'Theme Demo',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        backgroundColor: context.surfaceColor,
        trailing: const ThemeToggleWidget(showLabel: false),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(context, 'Colors', [
                _buildColorDemo(context, 'Primary', context.primaryColor),
                _buildColorDemo(context, 'Background', context.backgroundColor),
                _buildColorDemo(context, 'Surface', context.surfaceColor),
                _buildColorDemo(context, 'Text', context.textColor),
                _buildColorDemo(
                  context,
                  'Secondary Text',
                  context.secondaryTextColor,
                ),
              ]),
              const SizedBox(height: 24),
              _buildSection(context, 'Status Colors', [
                _buildColorDemo(context, 'Error', context.errorColor),
                _buildColorDemo(context, 'Success', context.successColor),
                _buildColorDemo(context, 'Warning', context.warningColor),
                _buildColorDemo(context, 'Info', context.infoColor),
              ]),
              const SizedBox(height: 24),
              _buildSection(context, 'Typography', [
                ThemedText(
                  'Display Large',
                  style: context.materialTheme.textTheme.displayLarge,
                ),
                ThemedText(
                  'Headline Large',
                  style: context.materialTheme.textTheme.headlineLarge,
                ),
                ThemedText(
                  'Title Large',
                  style: context.materialTheme.textTheme.titleLarge,
                ),
                ThemedText(
                  'Body Large',
                  style: context.materialTheme.textTheme.bodyLarge,
                ),
                ThemedText(
                  'Body Medium',
                  style: context.materialTheme.textTheme.bodyMedium,
                ),
                ThemedText(
                  'Label Small',
                  style: context.materialTheme.textTheme.labelSmall,
                  isSecondary: true,
                ),
              ]),
              const SizedBox(height: 24),
              _buildSection(context, 'Components', [
                ThemedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ThemedText(
                        'Themed Card',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ThemedText(
                        'This is a themed card that adapts to light and dark modes.',
                        isSecondary: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ThemedButton(
                        text: 'Primary Button',
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ThemedButton(
                        text: 'Outlined',
                        isOutlined: true,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ThemedButton(
                  text: 'Text Button',
                  isText: true,
                  icon: CupertinoIcons.star,
                  onPressed: () {},
                ),
                const SizedBox(height: 16),
                const ThemedDivider(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ThemedIcon(CupertinoIcons.heart),
                    const SizedBox(width: 12),
                    ThemedIcon(
                      CupertinoIcons.star_fill,
                      color: context.warningColor,
                    ),
                    const SizedBox(width: 12),
                    ThemedIcon(
                      CupertinoIcons.checkmark_circle,
                      color: context.successColor,
                    ),
                    const SizedBox(width: 12),
                    const ThemedLoadingIndicator(),
                  ],
                ),
              ]),
              const SizedBox(height: 24),
              _buildSection(context, 'Theme Controls', [
                const ThemeToggleWidget(),
                const SizedBox(height: 16),
                ThemedText(
                  'Current theme: ${context.watchTheme.themeModeString}',
                  isSecondary: true,
                ),
                ThemedText(
                  context.watchTheme.themeDescription,
                  isSecondary: true,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ThemedText(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildColorDemo(BuildContext context, String name, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: context.isDarkMode ? Colors.white24 : Colors.black12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ThemedText(name),
          const Spacer(),
          ThemedText(
            '#${color.value.toRadixString(16).toUpperCase().padLeft(8, '0')}',
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            isSecondary: true,
          ),
        ],
      ),
    );
  }
}
