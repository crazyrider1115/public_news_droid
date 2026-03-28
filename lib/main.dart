import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/signup_screen.dart';

void main() {
  runApp(const PublicNewsDroid());
}

class PublicNewsDroid extends StatelessWidget {
  const PublicNewsDroid({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // ✅ FIXED
      debugShowCheckedModeBanner: false,

      initialRoute: "/login",

      routes: {
        "/login": (context) => LoginScreen(),
        "/signup": (context) => SignupScreen(),
        "/home": (context) => HomeScreen(),
      },
    );
  }
}