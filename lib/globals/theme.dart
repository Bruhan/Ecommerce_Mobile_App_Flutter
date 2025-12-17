import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color brand = Color(0xFF326638); //greee color
  static const Color primary = brand;
  static const Color surface = Color(0xFFFFFFFF); // pure white 
  static const Color bg = Color(0xFFFBF9F6); // off-white 
  static const Color textPrimary = brand; // headings & primary text
  static const Color textSecondary = Color(0xFF8AA089); // lighter green for secondary text

  // Borders / fields
  static const Color divider = Color(0xFFEDEBE8);
  static const Color fieldBorder = Color(0xFFE6E4E1);

  // Button color alias
  static const Color buttonGreen = brand;

  // Muted / support colors
  static const Color muted = Color(0xFF9FB89F); // even lighter green tint
  static const Color accent = Color(0xFFF6F6F6); // neutral accent used earlier

  // Status
  static const Color success = Color(0xFF2ECC71);
  static const Color danger = Color(0xFFE53935);

  // Field background (slightly lighter than page)
  static const Color fieldBackground = Color(0xFFF7F6F4);
}

class AppSpacing {
  static const xs = 6.0;
  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 18.0;
  static const xl = 22.0;
  static const xxl = 30.0;
}

class AppRadii {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 14.0;
}

class AppTextStyles {
  AppTextStyles._();

  static final h1 = TextStyle(
    fontFamily: 'Melodrama',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static final h2 = TextStyle(
    fontFamily: 'Melodrama',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static final body = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 14,
    color: AppColors.textPrimary,
    height: 1.45,
  );

  static final caption = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static final subtitle = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 14,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static final label = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}

/// Build the app theme (Material 3 compatible)
ThemeData buildAppTheme() {
  final base = ThemeData(useMaterial3: true);

  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.surface,
    secondary: AppColors.buttonGreen,
    onSecondary: AppColors.surface,
    background: AppColors.bg,
    onBackground: AppColors.textPrimary,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    error: AppColors.danger,
    onError: Colors.white,
  );

  return base.copyWith(
    useMaterial3: true,
    colorScheme: colorScheme,

    scaffoldBackgroundColor: AppColors.bg,
    primaryColor: AppColors.primary,
    canvasColor: AppColors.surface,

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.h2.copyWith(fontSize: 18),
      iconTheme: const IconThemeData(color: AppColors.brand),
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: AppTextStyles.caption,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: AppColors.fieldBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        borderSide: BorderSide(color: AppColors.fieldBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        borderSide: BorderSide(color: AppColors.fieldBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        borderSide: BorderSide(color: AppColors.buttonGreen, width: 1.4),
      ),
    ),

    // Elevated Buttons (primary) - green
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonGreen,
        foregroundColor: AppColors.surface,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.lg)),
        textStyle: AppTextStyles.label.copyWith(color: AppColors.surface, fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    // Outlined buttons - green border/text
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.buttonGreen,
        side: BorderSide(color: AppColors.fieldBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.lg)),
        textStyle: AppTextStyles.label,
      ),
    ),

    // Text buttons - green text
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.buttonGreen,
        textStyle: AppTextStyles.label,
      ),
    ),

    // Chip theme (category chips)
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.buttonGreen.withOpacity(0.12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      labelStyle: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
      secondaryLabelStyle: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    // Bottom nav
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.buttonGreen,
      unselectedItemColor: AppColors.muted,
      selectedLabelStyle: AppTextStyles.caption.copyWith(color: AppColors.buttonGreen),
      unselectedLabelStyle: AppTextStyles.caption,
      type: BottomNavigationBarType.fixed,
      elevation: 6,
    ),

    // Card theme (CardThemeData)
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
      margin: EdgeInsets.zero,
    ),

    // Dialog theme (DialogThemeData)
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      titleTextStyle: AppTextStyles.h2,
      contentTextStyle: AppTextStyles.body,
    ),

    // Divider
    dividerColor: AppColors.divider,
    dividerTheme: DividerThemeData(color: AppColors.divider, thickness: 1),

    // Snackbar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.buttonGreen,
      contentTextStyle: AppTextStyles.body.copyWith(color: AppColors.surface),
      behavior: SnackBarBehavior.floating,
      actionTextColor: AppColors.surface,
    ),

    // Icon theme default color -> brand green
    iconTheme: const IconThemeData(color: AppColors.brand),

    // Toggle components
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
        (states) => states.contains(MaterialState.selected) ? AppColors.buttonGreen : AppColors.muted,
      ),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
        (states) => states.contains(MaterialState.selected)
            ? AppColors.buttonGreen.withOpacity(0.32)
            : AppColors.muted.withOpacity(0.18),
      ),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
        (states) => states.contains(MaterialState.selected) ? AppColors.buttonGreen : AppColors.muted,
      ),
    ),

    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
        (states) => states.contains(MaterialState.selected) ? AppColors.buttonGreen : AppColors.muted,
      ),
    ),

    // Apply named text styles to theme textTheme as fallbacks
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.h1,
      headlineMedium: AppTextStyles.h2,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.caption,
      labelLarge: AppTextStyles.label,
    ),
  );
}
