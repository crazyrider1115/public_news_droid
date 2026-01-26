import 'package:flutter/material.dart';
import '../services/news_api_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public News Droid'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: NewsApiService.fetchTopHeadlines(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading news'));
          }

          final articles = snapshot.data!;

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return ListTile(
                title: Text(article['title'] ?? 'No title'),
                subtitle: Text(article['source']['name'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}
