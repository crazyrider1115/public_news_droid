import 'package:flutter/material.dart';
import '../widgets/category_filter.dart';
import '../widgets/date_filter.dart';
import '../widgets/app_drawer.dart';
import '../services/news_api_service.dart';
import 'news_detail_screen.dart';

class FindNewsScreen extends StatefulWidget {
  const FindNewsScreen({super.key});

  @override
  State<FindNewsScreen> createState() => _FindNewsScreenState();
}

class _FindNewsScreenState extends State<FindNewsScreen> {
  String selectedCategory = 'All';
  DateTime? selectedDate;
  Future<List<dynamic>>? _future;

  void fetchFilteredNews() {
    final category = selectedCategory.toLowerCase();

    final date = selectedDate == null
        ? null
        : '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';

    setState(() {
      _future = NewsApiService.fetchFilteredNews(
        category: category,
        date: date,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find News'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CategoryFilter(
              selectedCategory: selectedCategory,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 12),
            DateFilter(
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: fetchFilteredNews,
              child: const Text('Search'),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: _future == null
                  ? const Center(child: Text('Search news here'))
                  : FutureBuilder<List<dynamic>>(
                      future: _future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return const Center(child: Text('Error loading news'));
                        }

                        final articles = snapshot.data ?? [];

                        if (articles.isEmpty) {
                          return const Center(child: Text('No news found'));
                        }

                        return ListView.builder(
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            final imageUrl = article['urlToImage'] ?? article['image'];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => NewsDetailScreen(article: article),
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                      child: Image.network(
                                        imageUrl ?? "https://via.placeholder.com/300",
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article['title'] ?? 'No title',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            article['source'] ?? 'News Source',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}