import 'package:flutter/material.dart';
import 'color_row_theme.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

class ThemeApp extends ThemeExtension<ThemeApp> {
  // static const Color primaryColor = Color(0xFF1B4C98); //Azul
  // static const Color primaryColorLight = Color(0xFFF5F5F5); //Gris
  // static const Color secondaryColor = Color(0xFF009FE3); //Azul
  // static const Color errorColor = Color(0xFFB00020);

  final Color primaryColor;
  final Color secondaryColor;
  final Color neutralColor;

  const ThemeApp({
    this.primaryColor = const Color(0xFF1B4C98),
    this.secondaryColor = const Color(0xFF009FE3),
    this.neutralColor = const Color(0xFFB8B8B8),
  });

  @override
  ThemeApp copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? neutralColor,
  }) {
    return ThemeApp(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      neutralColor: neutralColor ?? this.neutralColor,
    );
  }

  @override
  ThemeApp lerp(covariant ThemeExtension<ThemeApp>? other, double t) {
    if (other is! ThemeApp) {
      return this;
    }
    return ThemeApp(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      neutralColor: Color.lerp(neutralColor, other.neutralColor, t)!,
    );
  }

  // falta agregar el esquema de colores
  ThemeData toThemeData({required bool isDark}) {
    final colorScheme = _scheme(isDark).toColorScheme();
    return _base(colorScheme).copyWith(brightness: colorScheme.brightness);
  }

  ThemeData _base(ColorScheme colorScheme) {
    // final primaryTextTheme = GoogleFonts.archivoTextTheme();
    // final secondaryTextTheme = GoogleFonts.montserratTextTheme();
    // final textTheme = primaryTextTheme.copyWith(displaySmall: secondaryTextTheme.displaySmall);
    final isDark = colorScheme.brightness == Brightness.dark;
    final colorRowTheme = ColorRowTheme(
      firstRowColor: isDark ? colorScheme.surfaceContainerLow : Colors.white,
      secondRowColor: colorScheme.surfaceContainerHighest,
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
        constraints: const BoxConstraints(maxHeight: 50),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        labelStyle: TextStyle(
          color: colorScheme.primary,
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
      // tabBarTheme: TabBarTheme(
      //   labelColor: Colors.white,
      //   labelStyle: const TextStyle(
      //     fontWeight: FontWeight.bold,
      //     fontSize: 14,
      //   ),
      //   dividerColor: colorScheme.primary,
      //   unselectedLabelColor: Colors.white,
      //   indicatorSize: TabBarIndicatorSize.tab,
      //   indicatorColor: Colors.white,
      // ),
    );
  }

  DynamicScheme _scheme(bool isDark) {
    final base = CorePalette.of(primaryColor.toARGB32());
    final primary = base.primary;
    final tertiary = CorePalette.of(secondaryColor.toARGB32()).primary;
    final neutral = CorePalette.of(neutralColor.toARGB32()).neutral;

    return DynamicScheme(
      isDark: isDark,
      neutralPalette: neutral,
      primaryPalette: primary,
      secondaryPalette: base.secondary,
      tertiaryPalette: tertiary,
      neutralVariantPalette: base.neutralVariant,
      sourceColorArgb: primaryColor.toARGB32(),
      variant: Variant.vibrant,
    );
  }

  // static const Color primaryColor = Color(0xFF1B4C98); //Azul
  // static const Color primaryColorLight = Color(0xFFF5F5F5); //Gris
  // static const Color primaryColorDark = Color(0xFFB8B8B8); //Gris

  // static const Color secondaryColor = Color(0xFF009FE3); //Azul
  // static const Color secondaryColorDark = Color(0xFF103073); //Azul

  // static const Color accentColor = Color(0xFFC5C4C4);

  // static ThemeData getTheme() => ThemeData(
  //       fontFamily: "Kanit",
  //       //useMaterial3: true,
  //       useMaterial3: true,
  //       colorScheme: const ColorScheme.dark(
  //         /* primary: primaryColor,
  //         // primaryVariant: primaryColorDark,
  //         secondary: secondaryColor,
  //         // secondaryVariant: secondaryColorDark,
  //         brightness: Brightness.light, */
  //         primary: primaryColor,
  //         // primaryVariant: primaryColorDark,
  //         secondary: secondaryColor,
  //         onSurface: secondaryColor,
  //         onError: secondaryColor,
  //         onPrimary: Colors.white,
  //         onSecondary: secondaryColor,
  //         brightness: Brightness.light,
  //       ),
  //       primaryColor: primaryColor,
  //       dividerColor: primaryColor,
  //       appBarTheme: const AppBarTheme(centerTitle: true, elevation: 1),
  //       cardTheme: const CardTheme(
  //         elevation: 3,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(15)),
  //         ),
  //       ),
  //       switchTheme: SwitchThemeData(
  //         thumbColor: WidgetStateProperty.resolveWith(
  //           (states) {
  //             if (states.contains(WidgetState.disabled)) {
  //               return Colors.grey;
  //             }
  //             return Colors.white;
  //           },
  //         ),
  //         trackColor: WidgetStateProperty.resolveWith(
  //           (states) {
  //             if (states.contains(WidgetState.disabled)) {
  //               return Colors.grey[800];
  //             }
  //             return primaryColor;
  //           },
  //         ),
  //       ),
  //       radioTheme: RadioThemeData(
  //         fillColor: WidgetStateProperty.all(primaryColor),
  //       ),
  //       // inputDecorationTheme: inputDecorationGradient(),

  //       elevatedButtonTheme: ElevatedButtonThemeData(
  //         style: ElevatedButton.styleFrom(
  //           elevation: 3,
  //           backgroundColor: primaryColor,
  //           foregroundColor: Colors.white,
  //           iconColor: Colors.white,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(15),
  //           ),
  //           textStyle: const TextStyle(
  //             fontSize: 14,
  //             fontWeight: FontWeight.bold,
  //           ),
  //           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
  //         ),
  //       ),

  //       // inputDecorationTheme: InputDecorationTheme(
  //       //   border: OutlineInputBorder(
  //       //     borderRadius: BorderRadius.circular(10),
  //       //   ),
  //       // ),
  //       dropdownMenuTheme: DropdownMenuThemeData(
  //         inputDecorationTheme: inputDecorationTheme,
  //         textStyle: const TextStyle(
  //           color: primaryColor,
  //           fontSize: 14,
  //           fontWeight: FontWeight.bold,
  //         ),
  //         menuStyle: MenuStyle(
  //           maximumSize: WidgetStateProperty.all(const Size(420, 300)),
  //           backgroundColor: WidgetStateProperty.all(Colors.white),
  //           elevation: WidgetStateProperty.all(10),
  //           alignment: Alignment.bottomLeft,
  //           visualDensity: VisualDensity.adaptivePlatformDensity,
  //           shape: WidgetStateProperty.all(
  //             RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //           ),
  //         ),
  //       ),
  //       inputDecorationTheme: inputDecorationTheme,
  //       textButtonTheme: TextButtonThemeData(
  //         style: TextButton.styleFrom(
  //           foregroundColor: primaryColorDark,
  //         ),
  //       ),
  //       floatingActionButtonTheme: const FloatingActionButtonThemeData(
  //         backgroundColor: primaryColor,
  //         foregroundColor: Colors.white,
  //       ),
  //       bottomNavigationBarTheme: const BottomNavigationBarThemeData(
  //         unselectedItemColor: Colors.grey,
  //       ),
  //       chipTheme: const ChipThemeData(
  //         showCheckmark: false,
  //         backgroundColor: Color.fromARGB(255, 189, 189, 189),
  //         selectedColor: secondaryColor,
  //         labelStyle: TextStyle(color: Colors.white),
  //       ),
  //     );

  // // * Drop menu style
  // static const textDisableSelectDropDownStyle = TextStyle(
  //   fontSize: 14,
  //   color: Colors.black54,
  //   overflow: TextOverflow.ellipsis,
  // );

  static const textUnSelectDropDownStyle = TextStyle(
    fontSize: 14,
    color: Colors.black,
    overflow: TextOverflow.ellipsis,
  );

  // static const textSelectDropDownStyle = TextStyle(
  //   fontSize: 14,
  //   fontWeight: FontWeight.bold,
  //   overflow: TextOverflow.ellipsis,
  // );

  // /* + */
  // static final buttonStyle = ButtonStyleData(
  //   height: 50,
  //   width: 200,
  //   padding: const EdgeInsets.only(left: 14, right: 14),
  //   decoration: BoxDecoration(
  //     color: Colors.white,
  //     borderRadius: BorderRadius.circular(14),
  //     border: Border.all(color: Colors.black26),
  //   ),
  //   elevation: 1,
  // );

  // static const iconDropMenuStyle = IconStyleData(
  //   icon: Icon(
  //     Icons.arrow_forward_ios_outlined,
  //   ),
  //   iconSize: 20,
  // );

  // static final dropdownStyle = DropdownStyleData(
  //   maxHeight: 500,
  //   width: 300,
  //   padding: null,
  //   decoration: BoxDecoration(
  //     borderRadius: BorderRadius.circular(10),
  //   ),
  //   elevation: 8,
  //   offset: const Offset(-20, 0),
  //   scrollbarTheme: ScrollbarThemeData(
  //     radius: const Radius.circular(40),
  //     thickness: WidgetStateProperty.all<double>(6),
  //   ),
  // );

  // static const menuItemStyle = MenuItemStyleData(
  //   height: 40,
  //   padding: EdgeInsets.only(left: 14, right: 14),
  // );

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

  // static const inputDecorationTheme = InputDecorationTheme(
  //   filled: true,
  //   constraints: BoxConstraints(maxHeight: 50 //CAMBIAR/
  //       ),
  //   contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  //   fillColor: Colors.white,
  //   labelStyle: TextStyle(
  //     color: primaryColor,
  //   ),
  //   enabledBorder: OutlineInputBorder(
  //     borderSide: BorderSide(
  //       color: primaryColor,
  //     ),
  //   ),
  //   disabledBorder: OutlineInputBorder(
  //     borderSide: BorderSide(
  //       color: primaryColorDark,
  //     ),
  //   ),
  //   focusedBorder: OutlineInputBorder(
  //     borderSide: BorderSide(
  //       color: primaryColor,
  //     ),
  //   ),
  // );

  // static InputDecorationTheme outlineDecorationGradient() {
  //   final errorBorder = OutlineInputBorder(
  //     borderSide: BorderSide(
  //       style: BorderStyle.solid,
  //       color: Colors.red[500]!,
  //       width: 2,
  //     ),
  //     borderRadius: const BorderRadius.all(Radius.circular(15)),
  //   );
  //   const normalBorder = OutlineInputBorder(
  //     borderSide: BorderSide(
  //       style: BorderStyle.solid,
  //       color: primaryColor,
  //       width: 2,
  //     ),
  //     borderRadius: BorderRadius.all(Radius.circular(15)),
  //   );

  //   const disabledBorder = OutlineInputBorder(
  //     borderSide: BorderSide(
  //       style: BorderStyle.solid,
  //       color: Colors.white70,
  //       width: 2,
  //     ),
  //     borderRadius: BorderRadius.all(Radius.circular(15)),
  //   );

  //   return InputDecorationTheme(
  //     filled: true,
  //     fillColor: Colors.white,
  //     suffixIconColor: Colors.black,
  //     prefixIconColor: Colors.black,
  //     counterStyle: const TextStyle(color: Colors.white),
  //     iconColor: Colors.white,
  //     labelStyle: const TextStyle(color: Colors.black),
  //     border: normalBorder,
  //     enabledBorder: normalBorder,
  //     focusedBorder: normalBorder,

  //     // * disabled
  //     disabledBorder: disabledBorder,

  //     // * error
  //     errorBorder: errorBorder,
  //     focusedErrorBorder: errorBorder,
  //     errorStyle: const TextStyle(color: Colors.white),
  //   );
  // }

  // static BoxDecoration boxDecorationGradiente() => const BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [
  //           ThemeApp.primaryColorDark,
  //           ThemeApp.primaryColor,
  //         ],
  //         begin: Alignment.centerLeft,
  //         end: Alignment.centerRight,
  //         stops: [0.2, 0.95],
  //       ),
  //     );

  // static BoxDecoration buttonDecorationGradiente() => const BoxDecoration(
  //       borderRadius: BorderRadius.all(Radius.circular(5)),
  //       gradient: LinearGradient(
  //         colors: [
  //           ThemeApp.primaryColorDark,
  //           ThemeApp.primaryColor,
  //         ],
  //         begin: Alignment.centerLeft,
  //         end: Alignment.centerRight,
  //         stops: [0.2, 0.95],
  //       ),
  //     );
}

extension on DynamicScheme {
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
