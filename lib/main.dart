import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';


void main() {
  runApp(const PublicNewsDroid());
}

class PublicNewsDroid extends StatelessWidget {
  const PublicNewsDroid({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Public News Droid',
      home: const SearchScreen(),
    );
  }
}