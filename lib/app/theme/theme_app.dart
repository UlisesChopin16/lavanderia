import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

import 'color_row_theme.dart';

class ThemeApp extends ThemeExtension<ThemeApp> {
  final Color primaryColor;

  const ThemeApp({
    required this.primaryColor,
  });

  @override
  ThemeApp copyWith({
    Color? primaryColor,
  }) {
    return ThemeApp(
      primaryColor: primaryColor ?? this.primaryColor,
    );
  }

  @override
  ThemeApp lerp(covariant ThemeExtension<ThemeApp>? other, double t) {
    if (other is! ThemeApp) {
      return this;
    }
    return ThemeApp(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      // secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      // neutralColor: Color.lerp(neutralColor, other.neutralColor, t)!,
    );
  }

  // falta agregar el esquema de colores
  ThemeData toThemeData({required bool isDark}) {
    final colorScheme = _scheme(isDark, primaryColor).toColorScheme();
    return _base(colorScheme).copyWith(brightness: colorScheme.brightness);
  }

  ThemeData _base(ColorScheme colorScheme) {
    // final primaryTextTheme = GoogleFonts.archivoTextTheme();
    // final secondaryTextTheme = GoogleFonts.montserratTextTheme();
    // final textTheme = primaryTextTheme.copyWith(displaySmall: secondaryTextTheme.displaySmall);
    final isDark = colorScheme.brightness == Brightness.dark;
    final colorRowTheme = ColorRowTheme(
      firstRowColor: isDark ? colorScheme.surfaceContainerLow : Colors.white,
      secondRowColor:
          isDark ? colorScheme.surfaceContainerHighest : colorScheme.surfaceContainerLow,
    );
    return ThemeData(
      useMaterial3: true,
      extensions: [
        this,
        colorRowTheme,
      ],
      // textTheme: primaryTextTheme,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? colorScheme.surface : colorScheme.surfaceContainer,
      appBarTheme: AppBarTheme(
        elevation: 1,
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        // backgroundColor: isDark ? primaryColorTheme : colorScheme.primary,
        // foregroundColor: isDark ? Colors.white : colorScheme.onPrimary,
      ),
      cardTheme: CardThemeData(
        color: isDark ? colorScheme.surfaceContainer : Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? colorScheme.surface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? null : Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        labelStyle: TextStyle(
          color: colorScheme.primary,
        ),
        errorStyle: TextStyle(
          color: colorScheme.error,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.surfaceContainer,
          ),
        ),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: !isDark
              ? WidgetStateProperty.all(Colors.white)
              : WidgetStateProperty.all(colorScheme.surfaceContainer),
          surfaceTintColor: !isDark
              ? WidgetStateProperty.all(Colors.white)
              : WidgetStateProperty.all(colorScheme.surfaceContainer),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        indicatorColor: colorScheme.primary.withOpacity(0.2),
        unselectedIconTheme: IconThemeData(
          color: colorScheme.onSurfaceVariant,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w400,
        ),
        selectedIconTheme: IconThemeData(
          color: colorScheme.primary,
        ),
        selectedLabelTextStyle: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: !isDark ? Colors.white : colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: colorScheme.primary,
            width: 0.5,
          ),
        ),
        textStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14,
        ),
        elevation: 15,
      ),
    );
  }

  static DynamicScheme _scheme(bool isDark, Color colorData) {
    final base = CorePalette.of(colorData.toARGB32());
    final primary = base.primary;
    final secondary = base.secondary;
    final tertiary = base.tertiary;
    final neutral = base.neutral;
    final neutralVariant = base.neutralVariant;
    // final tertiary = CorePalette.of(secondaryColor.toARGB32()).primary;
    // final neutral = CorePalette.of(neutralColor.toARGB32()).neutral;

    return DynamicScheme(
      isDark: isDark,
      neutralPalette: neutral,
      primaryPalette: primary,
      secondaryPalette: secondary,
      tertiaryPalette: tertiary,
      neutralVariantPalette: neutralVariant,
      sourceColorArgb: colorData.toARGB32(),
      variant: Variant.vibrant,
    );
  }

  static ({InputDecoration inputDecoration, TextStyle style}) disableInputsProfile({
    required String labelText,
    required IconData icon,
    required BuildContext context,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    final decoration = InputDecoration(
      constraints: const BoxConstraints(maxHeight: double.infinity),
      labelText: labelText,
      contentPadding: const EdgeInsets.all(10),
      border: const OutlineInputBorder(),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      prefixIcon: Icon(
        icon,
        color: primaryColor,
      ),
    );
    return (
      inputDecoration: decoration,
      style: TextStyle(
        fontSize: 16,
        color: secondaryColor,
      ),
    );
  }

  static ColorScheme getColorScheme(Color colorData, bool isDark) {
    final scheme = _scheme(isDark, colorData);
    return scheme.toColorScheme();
  }
}

extension DynamicExt on DynamicScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: Color(primary),
      onPrimary: Color(onPrimary),
      secondary: Color(secondary),
      onSecondary: Color(onSecondary),
      error: Color(error),
      onError: Color(onError),
      surface: Color(surface),
      onSurface: Color(onSurface),
      errorContainer: Color(errorContainer),
      onErrorContainer: Color(onErrorContainer),
      primaryContainer: Color(primaryContainer),
      onPrimaryContainer: Color(onPrimaryContainer),
      secondaryContainer: Color(secondaryContainer),
      onSecondaryContainer: Color(onSecondaryContainer),
      tertiary: Color(tertiary),
      onTertiary: Color(onTertiary),
      tertiaryContainer: Color(tertiaryContainer),
      onTertiaryContainer: Color(onTertiaryContainer),
      shadow: Color(shadow),
      scrim: Color(scrim),
      inverseSurface: Color(inverseSurface),
      inversePrimary: Color(inversePrimary),
      onInverseSurface: Color(inverseOnSurface),
      outline: Color(outline),
      outlineVariant: Color(outlineVariant),
      onSurfaceVariant: Color(onSurfaceVariant),
      onPrimaryFixed: Color(onPrimaryFixed),
      onSecondaryFixed: Color(onSecondaryFixed),
      onTertiaryFixed: Color(onTertiaryFixed),
      onPrimaryFixedVariant: Color(onPrimaryFixedVariant),
      onSecondaryFixedVariant: Color(onSecondaryFixedVariant),
      onTertiaryFixedVariant: Color(onTertiaryFixedVariant),
      primaryFixed: Color(primaryFixed),
      secondaryFixed: Color(secondaryFixed),
      tertiaryFixed: Color(tertiaryFixed),
      primaryFixedDim: Color(primaryFixedDim),
      secondaryFixedDim: Color(secondaryFixedDim),
      tertiaryFixedDim: Color(tertiaryFixedDim),
      surfaceBright: Color(surfaceBright),
      surfaceContainer: Color(surfaceContainer),
      surfaceContainerHigh: Color(surfaceContainerHigh),
      surfaceContainerLow: Color(surfaceContainerLow),
      surfaceContainerHighest: Color(surfaceContainerHighest),
      surfaceContainerLowest: Color(surfaceContainerLowest),
      surfaceDim: Color(surfaceDim),
      surfaceTint: Color(surfaceTint),
    );
  }
}
