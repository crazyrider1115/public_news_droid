import 'package:flutter/material.dart';
import 'dart:convert'; // For json.decode
import 'package:http/http.dart' as http; // Make sure to run 'flutter pub add http'
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
  List<Map<String, dynamic>> filteredNews = [];
  bool isLoading = false; // To show the user that data is being fetched

  // The 10.0.2.2 IP is required for Android Emulators to see your computer's localhost
  final String backendUrl = "http://10.0.2.2:3000/api/news"; 

  @override
  void initState() {
    super.initState();
    filterNews(); // Fetch initial news on load
  }

  Future<void> filterNews() async {
    setState(() => isLoading = true);

    // 1. Prepare parameters for the live API
    // Standardize 'All' to empty and use lowercase for API compatibility
    String categoryParam = selectedCategory == 'All' ? '' : selectedCategory.toLowerCase();
    
    // Format date as YYYY-MM-DD for the backend
    String dateParam = selectedDate != null 
        ? "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}" 
        : "";

    try {
      // 2. Make the request to your Node.js backend
      final response = await http.get(
        Uri.parse("$backendUrl?category=$categoryParam&date=$dateParam")
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          filteredNews = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      // Show error to the user via SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not connect to backend: $e")),
      );
    }
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
                setState(() => selectedCategory = value!);
                filterNews(); // Refresh live data instantly
              },
            ),
            const SizedBox(height: 12),
            DateFilter(
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() => selectedDate = date);
                filterNews(); // Refresh live data instantly
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Results',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // UI Feedback: Show a spinner while the API is loading
            Expanded(
              child: isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : filteredNews.isEmpty
                  ? const Center(child: Text('No news found'))
                  : ListView.builder(
                      itemCount: filteredNews.length,
                      itemBuilder: (context, index) {
                        final news = filteredNews[index];
                        return Card(
                          child: ListTile(
                            title: Text(news['title'] ?? 'No Title'),
                            subtitle: Text(
                              '${news['category'] ?? 'General'} • ${news['date'] ?? ''}',
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