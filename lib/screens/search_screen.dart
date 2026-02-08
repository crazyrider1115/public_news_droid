import 'package:flutter/material.dart';
import '../widgets/category_filter.dart';
import '../widgets/date_filter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String selectedCategory = 'All';
  DateTime? selectedDate;

  // Dummy news data
  final List<Map<String, dynamic>> allNews = [
    {
      'title': 'Politics Today',
      'category': 'Politics',
      'date': DateTime(2026, 1, 20),
    },
    {
      'title': 'New Tech Launch',
      'category': 'Technology',
      'date': DateTime(2026, 1, 21),
    },
    {
      'title': 'Football Championship',
      'category': 'Sports',
      'date': DateTime(2026, 1, 22),
    },
    {
      'title': 'Stock Market Update',
      'category': 'Business',
      'date': DateTime(2026, 1, 20),
    },
  ];

  List<Map<String, dynamic>> filteredNews = [];

  void filterNews() {
    setState(() {
      filteredNews = allNews.where((news) {
        final matchesCategory = selectedCategory == 'All' ||
            news['category'] == selectedCategory;

        final matchesDate = selectedDate == null ||
            (news['date'].year == selectedDate!.year &&
                news['date'].month == selectedDate!.month &&
                news['date'].day == selectedDate!.day);

        return matchesCategory && matchesDate;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find News'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: filterNews,
                child: const Text('Search'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Results',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filteredNews.isEmpty
                  ? const Center(child: Text('No news found'))
                  : ListView.builder(
                      itemCount: filteredNews.length,
                      itemBuilder: (context, index) {
                        final news = filteredNews[index];
                        return Card(
                          child: ListTile(
                            title: Text(news['title']),
                            subtitle: Text(
                              '${news['category']} • ${news['date'].day}/${news['date'].month}/${news['date'].year}',
                            ),
                          ),
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
