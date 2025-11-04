import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/routes/route_generator.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/globals/theme.dart';

void main() {
  // Log framework errors to the console
  FlutterError.onError = (details) {
    FlutterError.dumpErrorToConsole(details);
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Alphabit Ecommerce App",
      theme: buildAppTheme(),
      initialRoute: Routes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,

      // Show an in-app error widget instead of a white screen
      builder: (context, child) {
        ErrorWidget.builder = (FlutterErrorDetails e) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Text(
                  e.exceptionAsString(),
                  style: const TextStyle(fontSize: 14, color: Colors.red),
                ),
              ),
            ),
          );
        };
        return child!;
      },
    );
  }
}
