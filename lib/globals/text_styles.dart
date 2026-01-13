import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  // Headings - Using Melodrama (your new choice for headings)
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Melodrama',
    fontSize: 28,
    fontWeight: FontWeight.w400, // Melodrama Regular - elegant and soft
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: 'Melodrama',
    fontSize: 22,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: 'Melodrama',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // Body text, subtitles, captions - Using Gilroy (clean, modern, highly readable)
  static const TextStyle body = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium - great for body text
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: const Color(0xFF6E6E6E),
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: const Color(0xFF9A9A9A),
  );

  // Buttons - Gilroy Bold for strong, clickable feel
  static const TextStyle button = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.1,
    color: Colors.white,
  );

  // Labels (form field labels, etc.)
  static const TextStyle label = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}
