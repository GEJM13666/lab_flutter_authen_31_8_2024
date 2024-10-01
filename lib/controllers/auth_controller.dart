import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

class AuthController {
  Future<String?> login(UserModel user) async {
    final response = await http.post(
      Uri.parse('http://your-backend-url/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token']; // Return token on successful login
    } else {
      return null; // Return null if login fails
    }
  }

  Future<bool> register(UserModel user) async {
    final response = await http.post(
      Uri.parse('http://your-backend-url/api/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    return response.statusCode == 200; // Return true on successful registration
  }
}
