library;

import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/responsive/size_extension.dart';
import 'package:flutter/material.dart';

///
/// Contains almost text UIs for applications.
///
class _BazUiText extends StatelessWidget {
  const _BazUiText({
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: maxLines,
      text,
      textAlign: textAlign,
      key: key,
      style: style,
    );
  }
}

class BazUiH1Text extends StatelessWidget {
  const BazUiH1Text({
    required this.text,
    super.key,
    this.color,
    this.textAlign,
    this.fontWeight,
  });

  final String text;

  final Color? color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return _BazUiText(
      text: text,
      textAlign: textAlign,
      style: context.textTheme.displayLarge?.copyWith(
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}

class BazUiH2Text extends StatelessWidget {
  const BazUiH2Text({
    required this.text,
    super.key,
    this.color,
    this.textAlign,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return _BazUiText(
      text: text,
      textAlign: textAlign,
      style: context.textTheme.headlineLarge?.copyWith(
        color: color,
      ),
    );
  }
}

class BazUiH3Text extends StatelessWidget {
  const BazUiH3Text({
    required this.text,
    super.key,
    this.color,
    this.textAlign,
    this.overflow,
    this.fontWeight,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return _BazUiText(
      text: text,
      textAlign: textAlign,
      style: context.textTheme.headlineMedium?.copyWith(
        color: color,
        overflow: overflow,
        fontWeight: fontWeight,
      ),
    );
  }
}

class BazUiH4Text extends StatelessWidget {
  const BazUiH4Text({
    required this.text,
    super.key,
    this.color,
    this.textAlign,
    this.overflow,
    this.height,
    this.fontSize,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final double? height;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return _BazUiText(
      text: text,
      textAlign: textAlign,
      style: context.textTheme.headlineSmall?.copyWith(
        color: color,
        overflow: overflow,
        height: height,
        fontSize: 24.0.sp,
      ),
    );
  }
}

class BazUiH5Text extends StatelessWidget {
  const BazUiH5Text({
    required this.text,
    super.key,
    this.color,
    this.textAlign,
    this.overflow,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return _BazUiText(
      text: text,
      textAlign: textAlign,
      style: context.textTheme.displayMedium?.copyWith(
        color: color,
        overflow: overflow,
      ),
    );
  }
}

class BazUiBodyText1 extends StatelessWidget {
  const BazUiBodyText1({
    required this.text,
    super.key,
    this.color,
    this.textAlign,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return _BazUiText(
      text: text,
      textAlign: textAlign,
      style: context.textTheme.labelLarge?.copyWith(
        color: color,
      ),
    );
  }
}

class BazUiBodyText2 extends StatelessWidget {
  const BazUiBodyText2({
    required this.text,
    super.key,
    this.color,
    this.textAlign,
    this.overflow,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return _BazUiText(
      text: text,
      textAlign: textAlign,
      style: context.textTheme.labelLarge?.copyWith(
        color: color,
        leadingDistribution: TextLeadingDistribution.even,
        overflow: overflow,
        fontSize: 14.0.sp,
      ),
    );
  }
}

class BazUiRegularBodyText1 extends StatelessWidget {
  const BazUiRegularBodyText1({
    required this.text,
    super.key,
    this.color,
    this.textAlign,
    this.overflow,
    this.leadingDistribution,
    this.maxLines,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final TextLeadingDistribution? leadingDistribution;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return _BazUiText(
      text: text,
      textAlign: textAlign,
      style: context.textTheme.bodyMedium?.copyWith(
        color: color,
        leadingDistribution: leadingDistribution,
        overflow: overflow,
      ),
      maxLines: maxLines,
    );
  }
}

class BazUiRegularBodyText2 extends StatelessWidget {
  const BazUiRegularBodyText2({
    required this.text,
    super.key,
    this.color,
    this.textAlign,
    this.overflow,
    this.fontWeight,
    this.maxLines,
    this.height,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final int? maxLines;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return _BazUiText(
      text: text,
      textAlign: textAlign,
      style: context.textTheme.bodySmall?.copyWith(
        color: color,
        leadingDistribution: TextLeadingDistribution.even,
        overflow: overflow,
        fontWeight: fontWeight,
        height: height,
      ),
      maxLines: maxLines,
    );
  }
}

class BazUiBodyText3 extends StatelessWidget {
  const BazUiBodyText3({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return _BazUiText(
      text: text,
      style: context.textTheme.labelMedium,
    );
  }
}

class BazUiRegularBodyText3 extends StatelessWidget {
  const BazUiRegularBodyText3({
    required this.text,
    super.key,
    this.color,
    this.textAlign,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return _BazUiText(
      text: text,
      textAlign: textAlign,
      style: context.textTheme.labelSmall?.copyWith(
        color: color,
        leadingDistribution: TextLeadingDistribution.even,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.2,
      ),
    );
  }
}
