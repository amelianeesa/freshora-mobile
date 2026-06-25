import 'package:flutter/material.dart';
import 'package:freshora_mobile/ui/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freshora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6B0D6B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B0D6B),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}