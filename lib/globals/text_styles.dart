import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  
  //headigs 
  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    height: 1.1,
    color: Colors.black,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: Colors.black,
  );

  /// REQUIRED: fixes `AppTextStyles.h3` missing error
  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: Colors.black,
  );

  
  //body text
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: Colors.black,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: Color(0xFF6E6E6E),
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.2,
    color: Color(0xFF9A9A9A),
  );

  //buttom 

  /// REQUIRED: fixes `AppTextStyles.button` missing error
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.1,
    color: Colors.white,
  );

  static final label = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}
