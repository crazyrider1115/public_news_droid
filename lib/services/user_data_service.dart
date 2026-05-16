import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserDataService {
  static const String baseUrl = 'https://public-news-droid.onrender.com/api/user';
  static const String authUrl = 'https://public-news-droid.onrender.com/api/auth';

  static Future<String?> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('current_username');
  }

  static Future<Map<String, dynamic>> saveNews(Map<String, dynamic> article) async {
    final username = await _getUsername();
    if (username == null) return {'success': false, 'message': 'Not logged in'};

    final response = await http.post(
      Uri.parse('$baseUrl/save-news'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'article': article,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> unsaveNews(String articleUrl) async {
    final username = await _getUsername();
    if (username == null) return {'success': false, 'message': 'Not logged in'};

    final response = await http.post(
      Uri.parse('$baseUrl/unsave-news'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'articleUrl': articleUrl,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getSavedNews() async {
    final username = await _getUsername();
    if (username == null) return [];

    final response = await http.post(
      Uri.parse('$baseUrl/get-saved-news'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username}),
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) {
      return data['savedNews'];
    }
    return [];
  }

  // Auth/Profile Additions
  static Future<Map<String, dynamic>> getProfile() async {
    final username = await _getUsername();
    if (username == null) return {'success': false};

    final response = await http.post(
      Uri.parse('$authUrl/profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateProfilePicture(String base64Image) async {
    final username = await _getUsername();
    final response = await http.post(
      Uri.parse('$authUrl/update-profile-picture'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'profilePicture': base64Image}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteProfilePicture() async {
    final username = await _getUsername();
    final response = await http.post(
      Uri.parse('$authUrl/delete-profile-picture'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateProfileDetails(String newName, String newUsername) async {
    final username = await _getUsername();
    final response = await http.post(
      Uri.parse('$authUrl/update-profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'currentUsername': username,
        'newUsername': newUsername,
        'newName': newName
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteAccount() async {
    final username = await _getUsername();
    final response = await http.post(
      Uri.parse('$authUrl/delete-account'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username}),
    );
    return jsonDecode(response.body);
  }
}
