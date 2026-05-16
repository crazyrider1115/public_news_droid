import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/news_tile.dart';
import '../services/user_data_service.dart';

class SavedNewsScreen extends StatefulWidget {
  const SavedNewsScreen({super.key});

  @override
  State<SavedNewsScreen> createState() => _SavedNewsScreenState();
}

class _SavedNewsScreenState extends State<SavedNewsScreen> {
  late Future<List<dynamic>> _savedNewsFuture;

  @override
  void initState() {
    super.initState();
    _savedNewsFuture = UserDataService.getSavedNews();
  }

  void _refresh() {
    setState(() {
      _savedNewsFuture = UserDataService.getSavedNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved News'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder<List<dynamic>>(
        future: _savedNewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
             return const Center(child: Text("Error loading saved news"));
          }

          final articles = snapshot.data ?? [];

          if (articles.isEmpty) {
             return const Center(child: Text("No saved news yet."));
          }

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return NewsTile(
                article: article,
                initialSaved: true,
                onSaveToggle: (isSaved) async {
                  if (!isSaved) {
                    await UserDataService.unsaveNews(article['link'] ?? article['url']);
                    _refresh();
                  } else {
                    await UserDataService.saveNews(article);
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
