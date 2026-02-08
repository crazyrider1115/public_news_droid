import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NewsApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/news/top';
    } else {
      // Android emulator
      return 'http://10.0.2.2:3000/news/top';
    }
  }

  /// Home screen – no filters
  static Future<List<dynamic>> fetchTopHeadlines() {
    return fetchFilteredNews();
  }

  /// Find News screen – optional filters
  static Future<List<dynamic>> fetchFilteredNews({
    String? category,
    String? date,
  }) async {
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        if (category != null) 'category': category,
        if (date != null) 'date': date,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }
}




