import 'package:flutter/material.dart';

import '../globals/theme.dart';
import '../modules/auth/screens/splash_screen.dart';
import '../modules/auth/screens/login_screen.dart';
import '../modules/home/screens/home_shell.dart';
import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _page(const SplashScreen());

      case Routes.login:
        return _page(const LoginScreen());

      case Routes.home:
        return _page(const HomeShell()); // ✅ This is your real home screen

      default:
        return _page(const _NotFound());
    }
  }

  static MaterialPageRoute _page(Widget child) =>
      MaterialPageRoute(builder: (_) => child);
}

class _NotFound extends StatelessWidget {
  const _NotFound();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Route not found', style: AppTextStyles.h2),
      ),
    );
  }
}
