import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

/// Extension methods for easy theme access throughout the app
extension ThemeExtensions on BuildContext {
  /// Get the current ThemeProvider instance
  ThemeProvider get themeProvider => Provider.of<ThemeProvider>(this, listen: false);
  
  /// Watch ThemeProvider for changes
  ThemeProvider get watchTheme => Provider.of<ThemeProvider>(this);
  
  /// Quick access to common theme properties
  bool get isDarkMode => watchTheme.isDarkMode;
  bool get isLightMode => watchTheme.isLightMode;
  Brightness get brightness => watchTheme.brightness;
  
  /// Color shortcuts
  Color get primaryColor => watchTheme.primaryColor;
  Color get backgroundColor => watchTheme.backgroundColor;
  Color get surfaceColor => watchTheme.surfaceColor;
  Color get textColor => watchTheme.textColor;
  Color get secondaryTextColor => watchTheme.secondaryTextColor;
  
  /// Status colors
  Color get errorColor => watchTheme.errorColor;
  Color get successColor => watchTheme.successColor;
  Color get warningColor => watchTheme.warningColor;
  Color get infoColor => watchTheme.infoColor;
  
  /// Theme data
  ThemeData get materialTheme => watchTheme.materialTheme;
  CupertinoThemeData get cupertinoTheme => watchTheme.cupertinoTheme;
}

/// Mixin for widgets that need theme-aware styling
mixin ThemeAware {
  /// Get theme colors based on current brightness
  Color getThemedColor(BuildContext context, {
    required Color lightColor,
    required Color darkColor,
  }) {
    return context.isDarkMode ? darkColor : lightColor;
  }
  
  /// Get adaptive text style
  TextStyle getThemedTextStyle(BuildContext context, {
    required TextStyle baseStyle,
    Color? lightColor,
    Color? darkColor,
  }) {
    final color = lightColor != null && darkColor != null
        ? getThemedColor(context, lightColor: lightColor, darkColor: darkColor)
        : context.textColor;
    
    return baseStyle.copyWith(color: color);
  }
  
  /// Get themed decoration
  BoxDecoration getThemedDecoration(BuildContext context, {
    Color? lightBackground,
    Color? darkBackground,
    double borderRadius = 8.0,
    bool hasShadow = true,
  }) {
    final backgroundColor = lightBackground != null && darkBackground != null
        ? getThemedColor(context, lightColor: lightBackground, darkColor: darkBackground)
        : context.surfaceColor;
    
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: hasShadow && context.isLightMode
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );
  }
}

/// Custom theme-aware widgets
class ThemedCard extends StatelessWidget with ThemeAware {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final bool hasShadow;
  final VoidCallback? onTap;

  const ThemedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 12.0,
    this.hasShadow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = getThemedDecoration(
      context,
      borderRadius: borderRadius,
      hasShadow: hasShadow,
    );

    Widget card = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: decoration,
      child: child,
    );

    if (onTap != null) {
      card = GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}

class ThemedButton extends StatelessWidget with ThemeAware {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final bool isOutlined;
  final bool isText;
  final IconData? icon;

  const ThemedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
    this.isOutlined = false,
    this.isText = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (isText) {
      return TextButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
        label: Text(text),
        style: style,
      );
    }

    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
        label: Text(text),
        style: style,
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
      label: Text(text),
      style: style,
    );
  }
}

class ThemedText extends StatelessWidget with ThemeAware {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isSecondary;

  const ThemedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = isSecondary ? context.secondaryTextColor : context.textColor;
    final textStyle = style?.copyWith(color: style?.color ?? defaultColor) ??
        TextStyle(color: defaultColor);

    return Text(
      text,
      style: textStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class ThemedIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final bool useSecondaryColor;

  const ThemedIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.useSecondaryColor = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ??
        (useSecondaryColor ? context.secondaryTextColor : context.textColor);

    return Icon(
      icon,
      size: size,
      color: iconColor,
    );
  }
}

class ThemedDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;

  const ThemedDivider({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness ?? 0.5,
      indent: indent,
      endIndent: endIndent,
      color: context.isDarkMode
          ? Colors.white.withOpacity(0.2)
          : Colors.black.withOpacity(0.1),
    );
  }
}

/// Theme-aware loading indicator
class ThemedLoadingIndicator extends StatelessWidget {
  final double? size;
  final Color? color;

  const ThemedLoadingIndicator({
    super.key,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 24,
      height: size ?? 24,
      child: CupertinoActivityIndicator(
        color: color ?? context.primaryColor,
      ),
    );
  }
}

/// Theme toggle widget for settings
class ThemeToggleWidget extends StatelessWidget {
  final bool showLabel;
  final String? customLabel;

  const ThemeToggleWidget({
    super.key,
    this.showLabel = true,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLabel) ...[
              ThemedIcon(themeProvider.themeIcon),
              const SizedBox(width: 8),
              ThemedText(
                customLabel ?? themeProvider.themeModeString,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 12),
            ],
            CupertinoSwitch(
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
              activeTrackColor: context.primaryColor,
            ),
          ],
        );
      },
    );
  }
}