import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/routes/routes.dart';

// Screens
import 'package:ecommerce_mobile/modules/auth/screens/splash_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/login_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/register_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/forgot_password_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/otp_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/reset_password_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _page(const SplashScreen());

      case Routes.login:
        return _page(const LoginScreen());

      case Routes.register:
        return _page(const RegisterScreen());

      case Routes.forgotPassword:
        return _page(const ForgotPasswordScreen());

      case Routes.otp:
        return _page(const OtpScreen());

      case Routes.resetPassword:
        return _page(const ResetPasswordScreen());

      default:
        return _page(const SplashScreen());
    }
  }

  static MaterialPageRoute _page(Widget child) =>
      MaterialPageRoute(builder: (_) => child);
}
