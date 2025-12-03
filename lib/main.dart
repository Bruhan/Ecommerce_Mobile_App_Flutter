import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// 🔹 Globals (contains plant ID and theme selector)
import 'globals/globals.dart';

// 🔹 Bookstore theme (existing)
import 'globals/theme.dart';

// 🔹 Clothing-store theme (new)
import 'globals/theme_cavier.dart';

import 'modules/auth/lib/jwt.dart';
import 'routes/route_generator.dart';
import 'routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storage = FlutterSecureStorage();

String decodeJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('Invalid JWT Token');
  }

  final payload = parts[1];
  final normalized = base64.normalize(payload);
  final decodedBytes = base64.decode(normalized);
  final decodedString = utf8.decode(decodedBytes);

  return decodedString;
}

Map<String, dynamic>? processJwt(String accessToken) {
  try {
    final decodedPayload = decodeJwt(accessToken);
    final payloadMap = json.decode(decodedPayload);

    return payloadMap;
  } catch (e) {
    print("Error decoding JWT: $e");
  }
  return null;
}

Future<void> clearStorageOnFirstLaunch() async {
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  if (isFirstLaunch) {
    await storage.deleteAll();
    await prefs.setBool('isFirstLaunch', false);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await clearStorageOnFirstLaunch();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<String> get jwtOrEmpty async {
    try {
      final jwt = await storage.read(key: "jwt").timeout(
        const Duration(seconds: 3),
        onTimeout: () => "",
      );
      debugPrint("jwt: $jwt");
      return jwt ?? "";
    } catch (e) {
      debugPrint("⚠️ SecureStorage read error: $e");
      await storage.deleteAll();
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    // --------------------------------------------------------------
    // ✅ OPTION 2 — If-else condition BEFORE building MaterialApp
    // --------------------------------------------------------------

    ThemeData selectedTheme;

    if (Globals.isClothingStore) {
      // Clothing-store → Modern Minimal + Poppins (theme_cavier.dart)
      selectedTheme = CavierTheme.themeData;
    } else {
      // Bookstore → Default Alphabit theme
      selectedTheme = buildAppTheme();
    }

    // --------------------------------------------------------------
    // MaterialApp now uses the selected theme
    // --------------------------------------------------------------

    return MaterialApp(
      title: 'Alphabit Ecommerce App',
      debugShowCheckedModeBanner: false,
      theme: selectedTheme, // <--- IMPORTANT CHANGE
      initialRoute: Routes.splash,
      onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
      builder: (context, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
      home: FutureBuilder(
        future: jwtOrEmpty,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            debugPrint("Error loading JWT: ${snapshot.error}");
            return _buildErrorScreen(context);
          }

          final token = snapshot.data ?? "";

          if (token.isEmpty) {
            return _navigateTo(context, Routes.login);
          }

          final decodedJWT = JWT.processJwt(token);

          if (decodedJWT == null) {
            return _navigateTo(context, Routes.login);
          }

          final expiration = DateTime.fromMillisecondsSinceEpoch(
            decodedJWT["exp"] * 1000,
          );

          if (expiration.isAfter(DateTime.now())) {
            return _navigateTo(context, Routes.home);
          } else {
            return _navigateTo(context, Routes.login);
          }

          Future.microtask(
              () => Navigator.pushReplacementNamed(context, Routes.login));
          return Container();
        },
      ),
    );
  }

  Widget _navigateTo(BuildContext context, String routeName) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, routeName);
      }
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            const Text("Something went wrong"),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, Routes.login);
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
