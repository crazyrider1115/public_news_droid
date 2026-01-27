import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class FindNewsScreen extends StatelessWidget {
  const FindNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find News')),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text(
          'Search news here',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
