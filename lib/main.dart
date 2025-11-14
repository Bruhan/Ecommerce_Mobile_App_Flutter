import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'globals/globals.dart';
import 'globals/theme.dart';
import 'routes/route_generator.dart';
import 'routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storage = FlutterSecureStorage();

String decodeJwt(String token) {
  final parts = token.split('.');
  if(parts.length != 3) {
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

    // print("Decoded Payload: $payloadMap");
    // print("Expiration: ${payloadMap['exp']}");
    // print("Subject: ${payloadMap['sub']}");
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
    // Clear all secure storage
    await storage.deleteAll();

    // Set first launch flag to false
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
    var jwt = await storage.read(key: "jwt") ?? "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alphabit Ecommerce App',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      // Start with splash screen
      initialRoute: Routes.splash,
      onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
      // Optional: smooth fade transition when switching routes
      builder: (context, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
        home: FutureBuilder(future: jwtOrEmpty, builder: (context, snapshot) {

          if(!snapshot.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator(),),);

          // print('Snapshot hasData: ${snapshot.hasData}');
          // print('Snapshot data: ${snapshot.data}');

          if(snapshot.data != null && snapshot.data != "") {
            var decodedJson = json.decode(snapshot.data!);

            if(decodedJson['accessToken'] != null) {

              var decoded = processJwt(decodedJson['accessToken']);
              print(decoded);

              if(decoded != null)  {


                var loginType = storage.read(key: "loginType");
                loginType.then((val) {
                    Globals.plant = decoded['plt'];

                    var expiration = DateTime.fromMillisecondsSinceEpoch(decoded["exp"] * 1000);


                    if(expiration.isAfter(DateTime.now())) {

                      Future.microtask(() => Navigator.pushReplacementNamed(context, Routes.home));
                      return Container();
                    }
                });

              }
            }
          }

          Future.microtask(() => Navigator.pushReplacementNamed(context, Routes.login));
          return Container();

        })
    );
  }
}
