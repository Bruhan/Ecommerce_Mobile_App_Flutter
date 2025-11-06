import 'package:flutter/material.dart';

class AppColors {
  static const primary = Colors.black;
  static const surface = Colors.white;
  static const bg = Color(0xFFF7F7F7);
  static const textPrimary = Color(0xFF111111);
  static const textSecondary = Color(0xFF6F6F6F);
  static const divider = Color(0xFFE9E9E9);
  static const fieldBorder = Color(0xFFE3E3E3);
  static const success = Color(0xFF2ECC71);
  static const danger = Color(0xFFE53935);

  static Color? fieldBackground;

  // static Color? get danger => null;
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
  static const h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.textPrimary,
  );
  static const h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const body = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );
  static const caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
  static const subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    height: 1.4,
  );
}

ThemeData buildAppTheme() {
  final base = ThemeData(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: AppColors.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: AppTextStyles.caption,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        borderSide: const BorderSide(color: AppColors.fieldBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        borderSide: const BorderSide(color: AppColors.fieldBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        borderSide: const BorderSide(color: AppColors.textPrimary, width: 1.2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    ),
    dividerColor: AppColors.divider,
  );
}
