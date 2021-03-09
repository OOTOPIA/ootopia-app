import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:convert';

import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/utils/fetch-data-exception.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String password);
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class AuthRepositoryImpl with SecureStoreMixin implements AuthRepository {
  @override
  Future<User> login(String email, String password) async {
    if (email != null && password != null) {
      final response = await http.post(
        DotEnv.env['API_URL'] + "users/login",
        headers: API_HEADERS,
        body:
            jsonEncode(<String, String>{"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        print("RESPONSE BODY ${response.body}");
        User user = User.fromJson(json.decode(response.body));

        await setAuthToken(user.token);
        await setCurrentUser(response.body);

        return user;
      } else if (response.statusCode == 403) {
        throw FetchDataException("INVALID_PASSWORD");
      } else {
        throw FetchDataException('Failed to login');
      }
    }
    return null;
  }

  @override
  Future<User> register(String name, String email, String password) async {
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

      print("RESPONSE BODY ${response.body}");

      if (response.statusCode == 201) {
        User user = User.fromJson(json.decode(response.body));
        await this.login(email, password);
        return user;
      } else {
        Map<String, dynamic> decode = json.decode(response.body);

        if (decode['error'] == "EMAIL_ALREADY_EXISTS") {
          throw FetchDataException(decode['error']);
        } else {
          throw FetchDataException('Failed to register');
        }
      }
    }
    return null;
  }
}
