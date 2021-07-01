import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/utils/fetch-data-exception.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String password);
  Future recoverPassword(String email);
  Future resetPassword(String newPassword);
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class AuthRepositoryImpl with SecureStoreMixin implements AuthRepository {
  Future<Map<String, String>> getRecoverPasswordHeader() async {
    String recoverPasswordToken = await getRecoverPasswordToken();
    if (recoverPasswordToken.isEmpty) {
      return API_HEADERS;
    }
    return {
      'Authorization': 'Bearer ' + recoverPasswordToken,
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  @override
  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(dotenv.env['API_URL']! + "users/login"),
      headers: API_HEADERS,
      body: jsonEncode(<String, String>{"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      print("LOGIN RESPONSE BODY ${response.body}");
      User user = User.fromJson(json.decode(response.body));

      await setAuthToken(user.token!);
      await setCurrentUser(response.body);

      return user;
    } else if (response.statusCode == 403) {
      throw FetchDataException("INVALID_PASSWORD");
    } else {
      throw FetchDataException('Failed to login');
    }
  }

  @override
  Future<User> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse(dotenv.env['API_URL']! + "users"),
      headers: API_HEADERS,
      body: jsonEncode(<String, dynamic>{
        "fullname": name,
        "email": email,
        "password": password,
        "acceptedTerms": true
      }),
    );

    print("REGISTER RESPONSE BODY ${response.body}");

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

  @override
  Future recoverPassword(String email) async {
    final response = await http.post(
      Uri.parse(dotenv.env['API_URL']! + "users/recover-password"),
      headers: API_HEADERS,
      body: jsonEncode(<String, dynamic>{
        "email": email,
      }),
    );

    print("RECOVER PASSWORD RESPONSE ${response.body}");

    if (response.statusCode != 200) {
      Map<String, dynamic> decode = json.decode(response.body);
      print("DECODED ERROR ${decode.toString()}");
      if (decode['error'] == "User not found") {
        throw FetchDataException("USER_NOT_FOUND");
      } else {
        throw FetchDataException('Failed to recover password');
      }
    }
  }

  @override
  Future resetPassword(String newPassword) async {
    if (newPassword == null) {
      return null;
    }
    final response = await http.post(
      Uri.parse(dotenv.env['API_URL']! + "users/reset-password"),
      headers: await getRecoverPasswordHeader(),
      body: jsonEncode(<String, dynamic>{
        "password": newPassword,
      }),
    );

    if (response.statusCode == 401) {
      throw FetchDataException("TOKEN_EXPIRED");
    } else if (response.statusCode != 200) {
      throw FetchDataException('Failed to reset password');
    }
  }
}
