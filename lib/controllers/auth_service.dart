import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../variables.dart';
import '../providers/user_provider.dart';

class AuthService {
  Future<UserModel?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$apiURL/api/user/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'user_name': username, 'password': password}),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      // Handle error response (optional)
      print('Login failed: ${response.body}');
      return null;
    }
  }

  Future<void> register(
      String username, String password, String name, String role) async {
    final response = await http.post(
      Uri.parse('$apiURL/api/user/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_name': username,
        'password': password,
        'name': name,
        'role': role,
      }),
    );

    print(response.statusCode);
    // Handle registration response if needed
  }

  Future<void> refreshToken(UserProvider userProvider) async {
  final refreshToken = userProvider.refreshToken;
  
  if (refreshToken == null) {
    throw Exception('Refresh token is null. Please press logout and relogin.');
  }

  final response = await http.post(
    Uri.parse('$apiURL/api/user/refresh'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'token': refreshToken,
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    userProvider.requestToken(responseData['accessToken']); // Update the access token
  } else {
    print('Failed to refresh token, Please press logout and relogin. : ${response.body}');
    throw Exception('Failed to refresh token, Please press logout and relogin.: ${response.body}');
  }
}

  
}
