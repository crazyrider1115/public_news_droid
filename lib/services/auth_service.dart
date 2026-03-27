import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://10.92.114.11:5000/api/auth";

  static Future<String> signUp(String name, String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'username': username,
        'password': password
      }),
    );

    final data = jsonDecode(response.body);
    return data['message'];
  }

  static Future<Map<String,dynamic>> signIn(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getPendingUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/pending'),
    );

    return jsonDecode(response.body);
  }

  static Future<void> approveUser(String username) async {
    await http.post(
      Uri.parse('$baseUrl/approve'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username
      }),
    );
  }
}