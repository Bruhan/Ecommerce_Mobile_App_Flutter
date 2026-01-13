import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/routes/routes.dart';

/// Auth
import 'package:ecommerce_mobile/modules/auth/screens/splash_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/login_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/register_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/forgot_password_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/otp_screen.dart';
import 'package:ecommerce_mobile/modules/auth/screens/reset_password_screen.dart';

/// Home
import 'package:ecommerce_mobile/modules/home/screens/home_shell.dart';
import 'package:ecommerce_mobile/modules/home/screens/search_suggestions_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/search_results_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/saved_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/addresses_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/new_address_screen.dart';

/// Products
import 'package:ecommerce_mobile/modules/products/screens/product_details_screen.dart';
import 'package:ecommerce_mobile/modules/products/screens/reviews_screen.dart';

/// Cart / Checkout
import 'package:ecommerce_mobile/modules/cart/screens/cart_screen.dart';
import 'package:ecommerce_mobile/modules/checkout/screens/checkout_screen.dart';
import 'package:ecommerce_mobile/modules/checkout/screens/payments_screen.dart';

/// Payments
import 'package:ecommerce_mobile/modules/payment/screens/payment_method_screen.dart';
import 'package:ecommerce_mobile/modules/payment/screens/new_card_screen.dart';
import 'package:ecommerce_mobile/modules/payment/screens/upi_payment_screen.dart';

/// Orders
import 'package:ecommerce_mobile/modules/orders/screens/orders_screen.dart';
import 'package:ecommerce_mobile/modules/orders/screens/track_order_screen.dart';
import 'package:ecommerce_mobile/models/order_model.dart';

/// Notifications and Notification Settings
import 'package:ecommerce_mobile/modules/notifications/screens/notification_settings_screen.dart';
import 'package:ecommerce_mobile/modules/notifications/screens/notifications_screen.dart';

///Accounts Screens
import 'package:ecommerce_mobile/modules/home/screens/faqs_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/help_center_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      /// AUTH
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

      /// HOME
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeShell());

      case Routes.search:
      case Routes.searchSuggestions:
        return MaterialPageRoute(
            builder: (_) => const SearchSuggestionsScreen());

      case Routes.searchResults:
        return MaterialPageRoute(
          builder: (_) => const SearchResultsScreen(),
          settings: RouteSettings(arguments: args),
        );

      /// CART / SAVED
      case Routes.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());

      case Routes.saved:
        return MaterialPageRoute(builder: (_) => const SavedScreen());

      /// CHECKOUT
      case Routes.checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());

      case Routes.payment:
        return MaterialPageRoute(builder: (_) => const PaymentsScreen());

      /// ADDRESS
      case Routes.addresses:
        return MaterialPageRoute(builder: (_) => const AddressesScreen());

      case Routes.addressesNew:
        return MaterialPageRoute(builder: (_) => const NewAddressScreen());

      /// PAYMENT
      case Routes.paymentMethods:
        return MaterialPageRoute(builder: (_) => PaymentMethodScreen());

      case Routes.newCard:
        return MaterialPageRoute(builder: (_) => NewCardScreen());

      case Routes.upi:
        return MaterialPageRoute(builder: (_) => UpiPaymentScreen());

      /// PRODUCTS
      case Routes.productDetails:
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(
            data: args is Map<String, dynamic> ? args : {},
          ),
        );

      case Routes.reviews:
        return MaterialPageRoute(builder: (_) => const ReviewsScreen());

      /// ORDERS
      case Routes.orders:
        return MaterialPageRoute(builder: (_) => const OrdersScreen());

      case Routes.trackOrder:
        if (args is OrderModel) {
          return MaterialPageRoute(
            builder: (_) => TrackOrderScreen(order: args),
          );
        }
        return _errorRoute('Missing order data');

      /// NOTIFICATION SETTINGS
      case Routes.notificationSettings:
        return MaterialPageRoute(
          builder: (_) => const NotificationSettingsScreen(),
        );

      /// NOTIFICATIONS
      case Routes.notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
          settings: settings,
        );

      /// FAQS SCREEN
      case Routes.faqs:
        return MaterialPageRoute(
          builder: (_) => const FaqsScreen(),
        );

      /// HELP CENTER SCREEN
      case Routes.helpCenter:
        return MaterialPageRoute(
          builder: (_) => const HelpCenterScreen(),
        );

      /// DEFAULT
      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Page not found')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
