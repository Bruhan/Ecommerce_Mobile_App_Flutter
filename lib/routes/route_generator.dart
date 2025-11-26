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
import 'package:ecommerce_mobile/modules/home/screens/saved_screen.dart';

/// NEW SEARCH SCREENS
import 'package:ecommerce_mobile/modules/home/screens/search_suggestions_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/search_results_screen.dart';

/// Products
import 'package:ecommerce_mobile/modules/products/screens/product_details_screen.dart';
import 'package:ecommerce_mobile/modules/products/screens/reviews_screen.dart';

/// Addresses
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
import 'package:ecommerce_mobile/modules/checkout/screens/payments_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    debugPrint('Route requested: ${settings.name} — args: ${settings.arguments?.runtimeType}');

    switch (settings.name) {

      /// AUTH
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


      /// HOME
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeShell(), settings: settings);

      /// OLD SEARCH → Redirect to NEW SEARCH SUGGESTIONS
      case Routes.search:
        return MaterialPageRoute(
          builder: (_) => const SearchSuggestionsScreen(),
          settings: settings,
        );

      /// NEW SEARCH SCREENS
      case Routes.searchSuggestions:
        return MaterialPageRoute(
          builder: (_) => const SearchSuggestionsScreen(),
          settings: settings,
        );

      case Routes.searchResults:
        return MaterialPageRoute(
          builder: (_) => const SearchResultsScreen(),
          settings: RouteSettings(arguments: args),
        );


      /// CART, CHECKOUT, SAVED
      case Routes.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen(), settings: settings);

      case Routes.checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen(), settings: settings);

      case Routes.saved:
        return MaterialPageRoute(builder: (_) => const SavedScreen(), settings: settings);


      /// PAYMENT (Checkout)
      case Routes.payment:
        return MaterialPageRoute(builder: (_) => const PaymentsScreen(), settings: settings);


      /// ADDRESS BOOK
      case Routes.addresses:
        return MaterialPageRoute(builder: (_) => const AddressesScreen(), settings: settings);

      case Routes.addressesNew:
        return MaterialPageRoute(builder: (_) => const NewAddressScreen(), settings: settings);


      /// PAYMENT
      case Routes.paymentMethods:
        return MaterialPageRoute(builder: (_) => PaymentMethodScreen(), settings: settings);

      case Routes.newCard:
        return MaterialPageRoute(builder: (_) => NewCardScreen(), settings: settings);

      case Routes.upi:
        return MaterialPageRoute(builder: (_) => UpiPaymentScreen(), settings: settings);


      /// PRODUCTS
      case Routes.productDetails:
        final Map<String, dynamic> productArgs =
            (args is Map<String, dynamic>) ? args : {};
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(data: productArgs),
          settings: settings,
        );

      case Routes.reviews:
        return MaterialPageRoute(builder: (_) => const ReviewsScreen(), settings: settings);


      /// ORDERS
      case Routes.orders:
        return MaterialPageRoute(builder: (_) => const OrdersScreen(), settings: settings);

      case Routes.trackOrder:
        if (args is OrderModel) {
          return MaterialPageRoute(builder: (_) => TrackOrderScreen(order: args), settings: settings);
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Missing order data')),
          ),
          settings: settings,
        );


      /// DEFAULT
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text("Page not found")),
            body: Center(child: Text("No route defined for ${settings.name}")),
          ),
          settings: settings,
        );
    }
  }
}
