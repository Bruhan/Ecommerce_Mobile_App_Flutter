// lib/routes/route_generator.dart
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/routes/routes.dart';

/// Auth
import 'package:ecommerce_mobile/modules/auth/screens/splash_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/login_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/register_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/forgot_password_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/otp_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/reset_password_screen.dart';

/// Cart / Checkout / Home
import 'package:ecommerce_mobile/modules/cart/screens/cart_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/home_shell.dart';
import 'package:ecommerce_mobile/modules/home/screens/search_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/saved_screen.dart';

/// Products
import 'package:ecommerce_mobile/modules/products/screens/product_details_screen.dart';
import 'package:ecommerce_mobile/modules/products/screens/reviews_screen.dart';

/// Addresses (Address Book)
import 'package:ecommerce_mobile/modules/home/screens/addresses_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/new_address_screen.dart';

/// Payment screens
import 'package:ecommerce_mobile/modules/payment/screens/payment_method_screen.dart';
import 'package:ecommerce_mobile/modules/payment/screens/new_card_screen.dart';
import 'package:ecommerce_mobile/modules/payment/screens/upi_payment_screen.dart';

/// Orders
import 'package:ecommerce_mobile/modules/orders/screens/orders_screen.dart';
import 'package:ecommerce_mobile/modules/orders/screens/track_order_screen.dart';
import 'package:ecommerce_mobile/models/order_model.dart';

/// Checkout
import 'package:ecommerce_mobile/modules/checkout/screens/checkout_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    debugPrint('Route requested: ${settings.name} — args: ${settings.arguments?.runtimeType}');

    switch (settings.name) {
      /// Auth
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen(), settings: settings);

      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen(), settings: settings);

      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen(), settings: settings);

      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen(), settings: settings);

      case Routes.otp:
        return MaterialPageRoute(builder: (_) => const OtpScreen(), settings: settings);

      case Routes.resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen(), settings: settings);

      /// Home / Shell
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeShell(), settings: settings);

      case Routes.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen(), settings: settings);

      case Routes.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen(), settings: settings);

      case Routes.checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen(), settings: settings);

      case Routes.saved:
        return MaterialPageRoute(builder: (_) => const SavedScreen(), settings: settings);

      /// Addresses
      case Routes.addresses:
        return MaterialPageRoute(builder: (_) => const AddressesScreen(), settings: settings);

      case Routes.addressesNew:
        return MaterialPageRoute(builder: (_) => const NewAddressScreen(), settings: settings);

      /// Payment
      case Routes.paymentMethods:
        // Use non-const constructors to avoid const constructor errors if the class isn't const
        return MaterialPageRoute(builder: (_) => PaymentMethodScreen(), settings: settings);

      case Routes.newCard:
        return MaterialPageRoute(builder: (_) => NewCardScreen(), settings: settings);

      case Routes.upi:
        return MaterialPageRoute(builder: (_) => UpiPaymentScreen(), settings: settings);

      /// Product Details (accepts Map<String, dynamic> as arguments)
      case Routes.productDetails: {
        final Map<String, dynamic> productArgs =
            (args is Map<String, dynamic>) ? args : <String, dynamic>{};

        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(data: productArgs),
          settings: settings,
        );
      }

      /// Reviews
      case Routes.reviews:
        return MaterialPageRoute(builder: (_) => const ReviewsScreen(), settings: settings);

      /// Orders list
      case Routes.orders:
        return MaterialPageRoute(builder: (_) => const OrdersScreen(), settings: settings);

      /// Track Order (expects an OrderModel in arguments)
      case Routes.trackOrder:
        if (args is OrderModel) {
          return MaterialPageRoute(builder: (_) => TrackOrderScreen(order: args), settings: settings);
        } else {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Invalid route')),
              body: const Center(child: Text('Missing order data for tracking')),
            ),
            settings: settings,
          );
        }

      default:
        debugPrint('No route defined for ${settings.name}');
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Page not found')),
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings: settings,
        );
    }
  }
}
