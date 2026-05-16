import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../screens/home_screen.dart';
import '../screens/find_news_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/saved_news_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          // 🔹 Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.newspaper, color: Colors.white, size: 40),
                const SizedBox(height: 10),
                const Text(
                  'Public News Droid',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          // 🏠 Home
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),

          // 🗂 Categories
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categories'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const FindNewsScreen()),
              );
            },
          ),


          // 🔖 Saved News
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Saved News'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SavedNewsScreen()),
              );
            },
          ),

          // 👤 Profile
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),

          // ⚙️ Dark Mode Switch
          SwitchListTile(
             secondary: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
             title: const Text('Dark Mode'),
             value: themeProvider.isDarkMode,
             onChanged: (value) {
                themeProvider.toggleTheme(value);
             },
          ),

          // ℹ️ About
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'Public News Droid',
                applicationVersion: '1.0',
                children: [
                  Text('A simple news app built using Flutter'),
                ],
              );
            },
          ),

          Divider(),

          // 🚪 Logout
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
