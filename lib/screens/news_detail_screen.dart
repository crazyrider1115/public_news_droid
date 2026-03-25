import 'package:flutter/material.dart';

class NewsDetailScreen extends StatelessWidget {
  final Map article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News Detail"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🖼 IMAGE
            if (article['image'] != null)
              Image.network(
                article['image'],
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),

            const SizedBox(height: 10),

            /// 📰 TITLE
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                article['title'] ?? "No Title",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /// 📄 DESCRIPTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                article['description'] ?? "No Description",
                style: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
