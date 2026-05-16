import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/news_tile.dart';
import '../services/news_api_service.dart';
import '../services/user_data_service.dart';
import 'find_news_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public News Droid'),
        actions: [
          FutureBuilder<Map<String, dynamic>>(
            future: UserDataService.getProfile(),
            builder: (context, snapshot) {
              String? base64Image;
              if (snapshot.hasData && snapshot.data!['success'] == true) {
                base64Image = snapshot.data!['user']['profilePicture'];
              }
              return GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: (base64Image != null && base64Image.isNotEmpty)
                        ? MemoryImage(base64Decode(base64Image.split(',').last))
                        : null,
                    radius: 18,
                    child: (base64Image == null || base64Image.isEmpty)
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FindNewsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder<List<dynamic>>(
        future: NewsApiService.fetchTopHeadlines(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No news available'));
          }

          final articles = snapshot.data!;

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];

              return NewsTile(
                article: article,
                initialSaved: false, // Wait until we check backend if needed, for now standard feed
                onSaveToggle: (isSaved) {
                  if (isSaved) {
                    UserDataService.saveNews(article);
                  } else {
                    UserDataService.unsaveNews(article['link'] ?? article['url']);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}