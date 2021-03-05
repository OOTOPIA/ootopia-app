import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:convert';

import 'package:ootopia_app/data/models/users/user_model.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String password);
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> login(String email, String password) async {
    try {
      if (email != null && password != null) {
        final response = await http.post(
          DotEnv.env['API_URL'] + "users/login",
          headers: API_HEADERS,
          body: jsonEncode(
              <String, String>{"email": email, "password": password}),
        );

        if (response.statusCode == 200) {
          print("RESPONSE BODY ${response.body}");
          return User.fromJson(json.decode(response.body));
        } else {
          throw Exception('Failed to login');
        }
      }
    } catch (error) {
      throw Exception('Failed to login ' + error);
    }
    return null;
  }

  @override
  Future<User> register(String name, String email, String password) async {
    try {
      if (email != null && password != null) {
        final response = await http.post(
          DotEnv.env['API_URL'] + "users",
          headers: API_HEADERS,
          body: jsonEncode(<String, dynamic>{
            "fullname": name,
            "email": email,
            "password": password,
            "acceptedTerms": true
          }),
        );

        if (response.statusCode == 201) {
          print("RESPONSE BODY ${response.body}");
          return User.fromJson(json.decode(response.body));
        } else {
          throw Exception('Failed to register');
        }
      }
    } catch (error) {
      throw Exception('Failed to register ' + error);
    }
    return null;
  }
}
