import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NewsApiService {
  static String get baseUrl {
  if (kIsWeb) {
    return 'http://localhost:3000/news/top';
  } else {
    return 'http://10.0.2.2:3000/news/top';
  }
}


  static Future<List<dynamic>> fetchTopHeadlines() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }
}



