import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApiService {
  static const String apiKey = 'dda4035d6751412991c363509a8bf5f7';
  static const String baseUrl =
      'https://newsapi.org/v2/top-headlines?country=in';

  static Future<List<dynamic>> fetchTopHeadlines() async {
    final response =
        await http.get(Uri.parse('$baseUrl&apiKey=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }
}
