import 'package:flutter/material.dart';
import '../widgets/category_filter.dart';
import '../widgets/date_filter.dart';
import '../widgets/app_drawer.dart';
import '../services/news_api_service.dart';




class FindNewsScreen extends StatefulWidget {
  const FindNewsScreen({super.key});

  @override
  State<FindNewsScreen> createState() => _FindNewsScreenState();
}

class _FindNewsScreenState extends State<FindNewsScreen> {
  String selectedCategory = 'All';
  DateTime? selectedDate;
  Future<List<dynamic>>? futureNews;
  Future<List<dynamic>>? _newsFuture;
  Future<List<dynamic>>? _future;



void fetchFilteredNews() {
  final category =
      selectedCategory == 'All' ? null : selectedCategory.toLowerCase();

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

            final articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ListTile(
                  title: Text(article['title'] ?? ''),
                  subtitle: Text(article['source']['name'] ?? ''),
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


