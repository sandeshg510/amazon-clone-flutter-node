import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../constants/global_variables.dart';
import '../../../models/user.dart';

class AuthRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<User> signUp(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$uri/api/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Automatically sign in after successful registration
      return signIn(email, password);
    } else {
      final error = json['error'] ?? 'Sign up failed';
      throw Exception(error);
    }
  }

// Updated signIn method
  Future<User> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$uri/api/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'auth_token', value: data['token']);
      return User.fromMap(data); // Corrected here
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Sign in failed';
      throw Exception(error);
    }
  }

// Updated getUserData method
  Future<User> getUserData(String token) async {
    final response = await http.get(
      Uri.parse(uri),
      headers: {'x-auth-token': token},
    );

    if (response.statusCode == 200) {
      return User.fromMap(jsonDecode(response.body)); // Corrected here
    } else {
      final error =
          jsonDecode(response.body)['error'] ?? 'Failed to fetch user data';
      throw Exception(error);
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<bool> validateToken(String token) async {
    final response = await http.post(
      Uri.parse('$uri/tokenIsValid'),
      headers: {'x-auth-token': token},
    );

    return response.statusCode == 200 && jsonDecode(response.body) == true;
  }
}
