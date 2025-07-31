import 'package:flutter/material.dart';

class ColorRowTheme extends ThemeExtension<ColorRowTheme> {
  final Color firstRowColor;
  final Color secondRowColor;

  const ColorRowTheme({
    required this.firstRowColor,
    required this.secondRowColor,
  });

  @override
  ColorRowTheme copyWith({
    Color? firstRowColor,
    Color? secondRowColor,
  }) {
    return ColorRowTheme(
      firstRowColor: firstRowColor ?? this.firstRowColor,
      secondRowColor: secondRowColor ?? this.secondRowColor,
    );
  }

  @override
  ColorRowTheme lerp(covariant ThemeExtension<ColorRowTheme>? other, double t) {
    if (other is! ColorRowTheme) {
      return this;
    }
    return ColorRowTheme(
      firstRowColor: Color.lerp(firstRowColor, other.firstRowColor, t)!,
      secondRowColor: Color.lerp(secondRowColor, other.secondRowColor, t)!,
    );
  }

  Color getColor(int index) {
    return index % 2 == 0 ? firstRowColor : secondRowColor;
  }
}
