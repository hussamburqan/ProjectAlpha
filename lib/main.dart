import 'package:flutter/material.dart';
import 'package:projectalpha/HomePage/HomePage.dart';
import 'package:projectalpha/login/login.dart';
import 'package:projectalpha/login/register.dart';
import 'package:projectalpha/theme/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/login',
      routes: {
        '/homepage': (context) => const Homepage(),
        '/login': (context) => LoginPage(),
        '/reg': (context) => const RegForm(),
      },
    );
  }
}

