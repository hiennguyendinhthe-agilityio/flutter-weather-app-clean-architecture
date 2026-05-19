import 'package:flutter/material.dart';

class ExpenseCategoryListTheme
    extends ThemeExtension<ExpenseCategoryListTheme> {
  final TextStyle? categoryNameStyle;
  final TextStyle? categoryAmountStyle;

  const ExpenseCategoryListTheme({
    this.categoryNameStyle,
    this.categoryAmountStyle,
  });

  @override
  ExpenseCategoryListTheme copyWith({
    TextStyle? categoryNameStyle,
    TextStyle? categoryAmountStyle,
  }) {
    return ExpenseCategoryListTheme(
      categoryNameStyle: categoryNameStyle ?? this.categoryNameStyle,
      categoryAmountStyle: categoryAmountStyle ?? this.categoryAmountStyle,
    );
  }

  @override
  ExpenseCategoryListTheme lerp(
    ThemeExtension<ExpenseCategoryListTheme>? other,
    double t,
  ) {
    if (other is! ExpenseCategoryListTheme) return this;
    return ExpenseCategoryListTheme(
      categoryNameStyle: TextStyle.lerp(
        categoryNameStyle,
        other.categoryNameStyle,
        t,
      ),
      categoryAmountStyle: TextStyle.lerp(
        categoryAmountStyle,
        other.categoryAmountStyle,
        t,
      ),
    );
  }
}
