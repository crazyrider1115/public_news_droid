import 'package:flutter/material.dart';
import '../widgets/category_filter.dart';
import '../widgets/date_filter.dart';

class FindNewsScreen extends StatefulWidget {
  const FindNewsScreen({super.key});

  @override
  State<FindNewsScreen> createState() => _FindNewsScreenState();
}

class _FindNewsScreenState extends State<FindNewsScreen> {
  String selectedCategory = 'All';
  DateTime? selectedDate;
  Future<void> fetchFilteredNews() async {
  final category = selectedCategory.toLowerCase();

  final date = selectedDate == null
      ? ''
      : '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';

  print('Category: $category');
  print('Date: $date');
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find News')),

      body: Column(
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

          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  fetchFilteredNews();
                },
                child: const Text('Search'),
              ),
            ),
          ),
        ],
      drawer: AppDrawer(),
      body: const Center(
        child: Text(
          'Search news here',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

