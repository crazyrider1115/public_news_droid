import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: AppDrawer(), // 👈 MENU ATTACHED HERE
      body: Center(
        child: Text('Welcome to Public News Droid'),
      ),
    );
  }
}


