// lib/routes/route_generator.dart
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/routes/routes.dart';

// screens (use package imports so analyzer finds them reliably)
import 'package:ecommerce_mobile/modules/auth/screens/splash_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/login_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/home_shell.dart';
import 'package:ecommerce_mobile/modules/products/screens/product_details_screen.dart';
import 'package:ecommerce_mobile/modules/products/screens/reviews_screen.dart';
import 'package:ecommerce_mobile/modules/notifications/screens/notifications_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/discover_tab.dart';
import 'package:ecommerce_mobile/modules/auth/screens/register_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/forgot_password_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/otp_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/reset_password_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/search_screen.dart';

/// RouteGenerator: centralized route handling
/// This file is deliberately defensive:
/// - it validates `settings.arguments` before casting
/// - each case that needs a local variable uses its own block scope
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case Routes.otp:
        return MaterialPageRoute(builder: (_) => const OtpScreen());

      case Routes.resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());

      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeShell());

      case Routes.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      case Routes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());

      // product details expects a Map<String, dynamic>
      case Routes.productDetails: {
        final Map<String, dynamic> productArgs =
            (args is Map<String, dynamic>) ? args : <String, dynamic>{};
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(data: productArgs),
        );
      }

      // reviews (some versions of ReviewsScreen accept data, others don't).
      // We'll be defensive: if args is a map but ReviewsScreen doesn't accept params,
      // update the ReviewsScreen file instead. For now we call the parameterless constructor.
      case Routes.reviews: {
        // If your ReviewsScreen expects arguments, change the line below to:
        // final Map<String, dynamic> reviewsArgs = (args is Map<String, dynamic>) ? args : <String, dynamic>{};
        // return MaterialPageRoute(builder: (_) => ReviewsScreen(data: reviewsArgs));
        return MaterialPageRoute(builder: (_) => const ReviewsScreen());
      }

      // default fallback
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Page not found')),
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
