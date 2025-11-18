// lib/routes/route_generator.dart
import 'package:ecommerce_mobile/modules/checkout/screens/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/routes/routes.dart';

// Auth
import 'package:ecommerce_mobile/modules/auth/screens/splash_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/login_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/register_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/forgot_password_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/otp_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/reset_password_screen.dart';

// Cart / Checkout / Home
import 'package:ecommerce_mobile/modules/cart/screens/cart_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/home_shell.dart';
import 'package:ecommerce_mobile/modules/home/screens/search_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/saved_screen.dart';

// Products
import 'package:ecommerce_mobile/modules/products/screens/product_details_screen.dart';
import 'package:ecommerce_mobile/modules/products/screens/reviews_screen.dart';

// Addresses (Address Book)
import 'package:ecommerce_mobile/modules/home/screens/addresses_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/new_address_screen.dart';

// Payment screens
import 'package:ecommerce_mobile/modules/payment/screens/payment_method_screen.dart';
import 'package:ecommerce_mobile/modules/payment/screens/new_card_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      /// Auth
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

      /// Home / Shell
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeShell());

      case Routes.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      case Routes.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());

      case Routes.checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());

      case Routes.saved:
        return MaterialPageRoute(builder: (_) => const SavedScreen());

      /// Addresses
      case Routes.addresses:
        return MaterialPageRoute(builder: (_) => const AddressesScreen());

      case Routes.addressesNew:
        return MaterialPageRoute(builder: (_) => const NewAddressScreen());

      /// Payment
      case Routes.paymentMethod:
        return MaterialPageRoute(builder: (_) => const PaymentMethodScreen());

      case Routes.paymentNewCard:
        return MaterialPageRoute(builder: (_) => const NewCardScreen());

      /// Product Details
      case Routes.productDetails: {
        final Map<String, dynamic> productArgs =
            (args is Map<String, dynamic>) ? args : <String, dynamic>{};

        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(data: productArgs),
        );
      }

      /// Reviews
      case Routes.reviews:
        return MaterialPageRoute(builder: (_) => const ReviewsScreen());

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
