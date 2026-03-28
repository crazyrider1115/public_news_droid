import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/find_news_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          // 🔹 Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.newspaper, color: Colors.white, size: 40),
                SizedBox(height: 10),
                Text(
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
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),

          // 🔍 Find News
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Find News'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => FindNewsScreen()),
              );
            },
          ),

          // 🗂 Categories
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Categories'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Categories clicked')),
              );
            },
          ),

          // 🔖 Saved News
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('Saved News'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Saved News clicked')),
              );
            },
          ),

          // 👤 Profile
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),

          // ⚙️ Settings
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Settings clicked')),
              );
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
