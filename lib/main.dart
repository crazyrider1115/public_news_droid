import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'providers/theme_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    await messaging.subscribeToTopic('all_news');
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const PublicNewsDroid(),
    ),
  );
}

class PublicNewsDroid extends StatelessWidget {
  const PublicNewsDroid({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
         brightness: Brightness.light,
         appBarTheme: const AppBarTheme(
           backgroundColor: Colors.white,
           foregroundColor: Colors.black,
         ),
      ),
      darkTheme: ThemeData(
         brightness: Brightness.dark,
      ),
      initialRoute: "/login",

      routes: {
        "/login": (context) => const LoginScreen(),
        "/signup": (context) => const SignupScreen(),
        "/home": (context) => const HomeScreen(),
      },
    );
  }
}