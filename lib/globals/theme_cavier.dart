import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CavierColors {
  CavierColors._();

  static const Color charcoal = Color(0xFF111111);
  static const Color gold = Color(0xFFD4AF37); 
  static const Color logoBlue = Color(0xFF1E88E5);
  static const Color logoRed = Color(0xFFE53935); 
  static const Color navy = Color(0xFF0C2D48);
  static const Color pageBg = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF8A8A8A);
  static const Color border = Color(0xFFF2F2F2);
  static const Color success = Color(0xFF1B8A4A);
  static const Color error = logoRed;
}

class CavierTextStyles {
  CavierTextStyles._();

  static TextTheme textTheme([Color? color]) {
    final base = color ?? CavierColors.charcoal;
    final baseTheme = GoogleFonts.poppinsTextTheme().apply(
      bodyColor: base,
      displayColor: base,
    );

    return baseTheme.copyWith(
      displayLarge:
          GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w700, color: base),
      displayMedium:
          GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: base),
      displaySmall:
          GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: base),
      headlineMedium:
          GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: base),
      headlineSmall:
          GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: base),
      titleLarge:
          GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: base),
      titleMedium:
          GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: base),
      titleSmall:
          GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: base),
      bodyLarge:
          GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400, color: base),
      bodyMedium:
          GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: base),
      bodySmall:
          GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: base),
      labelLarge:
          GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: base),
      labelSmall:
          GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: CavierColors.muted),
    );
  }
}

class CavierTheme {
  CavierTheme._();

  static final ColorScheme _scheme = ColorScheme(
    brightness: Brightness.light,
    primary: CavierColors.charcoal,
    onPrimary: CavierColors.pageBg,
    secondary: CavierColors.gold,   //gold
    onSecondary: Colors.black,
    background: CavierColors.pageBg,
    onBackground: CavierColors.charcoal,
    surface: CavierColors.surface,
    onSurface: CavierColors.charcoal,
    error: CavierColors.error,
    onError: Colors.white,
  );

  static final ThemeData themeData = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: _scheme,

    // Core colors
    scaffoldBackgroundColor: CavierColors.pageBg,
    canvasColor: CavierColors.surface,
    primaryColor: CavierColors.charcoal,

    // Typography
    textTheme: CavierTextStyles.textTheme(CavierColors.charcoal),
    primaryTextTheme: CavierTextStyles.textTheme(CavierColors.charcoal),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: CavierColors.pageBg,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: CavierColors.charcoal),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: CavierColors.charcoal,
      ),
      toolbarTextStyle: GoogleFonts.poppins(fontSize: 14, color: CavierColors.charcoal),
    ),

    // ElevatedButton (main CTA) - gold
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: CavierColors.gold,
        foregroundColor: Colors.black,
        textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
    ),

    // OutlinedButton - subtle border (white background)
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: CavierColors.charcoal,
        backgroundColor: CavierColors.surface,
        side: BorderSide(color: CavierColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    // TextButton - use logoBlue for link-like actions
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: CavierColors.logoBlue,
        textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    // Input / Search field
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: CavierColors.surface,
      hintStyle: GoogleFonts.poppins(fontSize: 14, color: CavierColors.muted.withOpacity(0.9)),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: CavierColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: CavierColors.border),
      ),
    ),

    // Card theme (CardThemeData)
    // cardTheme: CardThemeData(
    //   color: CavierColors.surface,
    //   elevation: 0,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //   margin: EdgeInsets.zero,
    // ),

    // Chip theme: selected uses logoBlue accent subtly
    chipTheme: ChipThemeData(
      backgroundColor: CavierColors.surface,
      selectedColor: CavierColors.logoBlue.withOpacity(0.08),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      labelStyle: GoogleFonts.poppins(fontSize: 13, color: CavierColors.charcoal),
      secondaryLabelStyle: GoogleFonts.poppins(fontSize: 13, color: CavierColors.charcoal),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
    ),

    // Bottom Navigation Bar: keep gold indicator, but unselected icons muted
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: CavierColors.surface,
      selectedItemColor: CavierColors.gold,
      unselectedItemColor: CavierColors.muted,
      selectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
      type: BottomNavigationBarType.fixed,
      elevation: 6,
    ),

    // Icon theme
    iconTheme: const IconThemeData(color: CavierColors.charcoal),

    // SnackBar: dark bg, gold action
    snackBarTheme: SnackBarThemeData(
      backgroundColor: CavierColors.charcoal,
      contentTextStyle: GoogleFonts.poppins(color: CavierColors.pageBg),
      behavior: SnackBarBehavior.floating,
      actionTextColor: CavierColors.gold,
    ),

    // Dialog theme (DialogThemeData)
    // dialogTheme: DialogThemeData(
    //   backgroundColor: CavierColors.surface,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //   titleTextStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: CavierColors.charcoal),
    //   contentTextStyle: GoogleFonts.poppins(fontSize: 14, color: CavierColors.charcoal),
    // ),

    // Divider
    dividerTheme: DividerThemeData(color: CavierColors.border, thickness: 1),

    // Toggle components (Switch/Checkbox/Radio)
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
        (states) => states.contains(MaterialState.selected) ? CavierColors.logoBlue : CavierColors.muted,
      ),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
        (states) => states.contains(MaterialState.selected)
            ? CavierColors.logoBlue.withOpacity(0.32)
            : CavierColors.muted.withOpacity(0.16),
      ),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
        (states) => states.contains(MaterialState.selected) ? CavierColors.logoBlue : CavierColors.muted,
      ),
    ),

    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
        (states) => states.contains(MaterialState.selected) ? CavierColors.logoBlue : CavierColors.muted,
      ),
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: CavierColors.navy,
      foregroundColor: Colors.white,
    ),
  );

  /// Helper to return this theme
  static ThemeData themeFromPlantId(String plantId) => themeData;
}
