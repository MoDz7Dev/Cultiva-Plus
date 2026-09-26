import 'package:cultiva_plus/config/theme/app_theme.dart';
import 'package:cultiva_plus/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme().theme(),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen()
    );
  }
}