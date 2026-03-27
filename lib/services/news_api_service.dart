import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApiService {
  static String get baseUrl {
    return 'https://public-news-droid.onrender.com/news/top';
  }

  static Future<List<dynamic>> fetchTopHeadlines() {
    return fetchFilteredNews();
  }

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