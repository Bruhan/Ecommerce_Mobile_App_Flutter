import 'package:flutter/material.dart';
import 'globals/theme.dart';
import 'routes/route_generator.dart';
import 'routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alphabit Ecommerce App',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      // Start with splash screen
      initialRoute: Routes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
      // Optional: smooth fade transition when switching routes
      builder: (context, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
    );
  }
}
