import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CavierColors {
  CavierColors._();

  // Brand Colors
  static const Color primary = Color(0xFF9C27B0); // Purple
  static const Color onPrimary = Colors.white;

  static const Color accent = Color(0xFFFF4081); // Pink
  static const Color onAccent = Colors.white;

  // Light Pink Background 
  static const Color background = Color(0xFFFFB6C1); // LightPink
  static const Color surface = Color(0xFFFFFFFF);    // Pure white

  // Text Colors
  static const Color textDark = Color(0xFF333333); // Dark gray
  static const Color muted = Color(0xFF777777);

  static const Color error = Color(0xFFFF5252);
}

class CavierTextStyles {
  CavierTextStyles._();

  static TextTheme textTheme([Color? color]) {
    final base = color ?? CavierColors.textDark;

    final baseTheme = GoogleFonts.poppinsTextTheme().apply(
      bodyColor: base,
      displayColor: base,
    );

    return baseTheme.copyWith(
      displayLarge: GoogleFonts.poppins(
          fontSize: 34, fontWeight: FontWeight.w700, color: base),
      displayMedium: GoogleFonts.poppins(
          fontSize: 28, fontWeight: FontWeight.w600, color: base),
      displaySmall: GoogleFonts.poppins(
          fontSize: 22, fontWeight: FontWeight.w600, color: base),
      headlineMedium: GoogleFonts.poppins(
          fontSize: 18, fontWeight: FontWeight.w600, color: base),
      headlineSmall: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.w600, color: base),
      titleLarge: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.w600, color: base),
      titleMedium: GoogleFonts.poppins(
          fontSize: 14, fontWeight: FontWeight.w500, color: base),
      titleSmall: GoogleFonts.poppins(
          fontSize: 12, fontWeight: FontWeight.w500, color: base),
      bodyLarge: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.w400, color: base),
      bodyMedium: GoogleFonts.poppins(
          fontSize: 14, fontWeight: FontWeight.w400, color: base),
      bodySmall: GoogleFonts.poppins(
          fontSize: 12, fontWeight: FontWeight.w400, color: base),
      labelLarge: GoogleFonts.poppins(
          fontSize: 14, fontWeight: FontWeight.w600, color: base),
      labelSmall: GoogleFonts.poppins(
          fontSize: 12, fontWeight: FontWeight.w600, color: CavierColors.muted),
    );
  }
}

class CavierTheme {
  CavierTheme._();

  static final ColorScheme _scheme = ColorScheme(
    brightness: Brightness.light,
    primary: CavierColors.primary,
    onPrimary: CavierColors.onPrimary,
    secondary: CavierColors.accent,
    onSecondary: CavierColors.onAccent,
    error: CavierColors.error,
    onError: Colors.white,
    surface: CavierColors.surface,
    onSurface: CavierColors.textDark,
    background: CavierColors.background,
    onBackground: CavierColors.textDark,
  );

  static final ThemeData themeData = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: _scheme,

    scaffoldBackgroundColor: CavierColors.background,
    canvasColor: CavierColors.surface,

    textTheme: CavierTextStyles.textTheme(CavierColors.textDark),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: CavierColors.background,
      elevation: 0,
      iconTheme: const IconThemeData(color: CavierColors.textDark),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: CavierColors.textDark,
      ),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: CavierColors.accent,
        foregroundColor: CavierColors.onAccent,
        textStyle:
            GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: CavierColors.primary,
        side: const BorderSide(color: CavierColors.primary, width: 1.3),
        textStyle:
            GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: CavierColors.primary,
        textStyle:
            GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    // Search Fields / Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: CavierColors.textDark.withOpacity(0.5),
      ),
      prefixIconColor: CavierColors.textDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),

    // Cards
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: CavierColors.primary,
      unselectedItemColor: CavierColors.muted,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 10,
    ),

    // Switches
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith(
        (states) =>
            states.contains(MaterialState.selected)
                ? CavierColors.primary
                : CavierColors.muted,
      ),
      trackColor: MaterialStateProperty.resolveWith(
        (states) =>
            states.contains(MaterialState.selected)
                ? CavierColors.primary.withOpacity(0.4)
                : CavierColors.muted.withOpacity(0.3),
      ),
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith(
        (states) =>
            states.contains(MaterialState.selected)
                ? CavierColors.primary
                : CavierColors.muted,
      ),
    ),

    // Radio
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith(
        (states) =>
            states.contains(MaterialState.selected)
                ? CavierColors.primary
                : CavierColors.muted,
      ),
    ),

    // Dialogs
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: CavierColors.textDark,
      ),
      contentTextStyle: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: CavierColors.textDark,
      ),
    ),
  );

  static ThemeData themeFromPlantId(String plantId) {
    return themeData;
  }
}
