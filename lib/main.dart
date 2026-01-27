import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/find_news_screen.dart';

void main() {
  runApp(const PublicNewsDroid());
}

class PublicNewsDroid extends StatelessWidget {
  const PublicNewsDroid({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/find-news': (context) => const FindNewsScreen(),
      },
    );
  }
}

