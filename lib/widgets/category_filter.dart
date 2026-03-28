import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String?> onChanged;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      'All',
      'Politics',
      'Technology',
      'Sports',
      'Business',
    ];

    return DropdownButtonFormField<String>(
      initialValue: selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      items: categories
          .map(
            (category) => DropdownMenuItem(
              value: category,
              child: Text(category),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
