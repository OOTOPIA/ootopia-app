import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ootopia_app/data/models/users/auth_model.dart';
import 'dart:convert';

import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/api.dart';
import 'package:ootopia_app/data/utils/fetch-data-exception.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/shared_preferences.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future register(Auth user, List<String>? tagsIds);
  Future recoverPassword(String email, String lang);
  Future resetPassword(String newPassword);
  Future<bool> emailExist(String email);
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class AuthRepositoryImpl with SecureStoreMixin implements AuthRepository {
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  late SharedPreferencesInstance prefs;

  AuthRepositoryImpl() {
    SharedPreferencesInstance.getInstace().then((value) {
      prefs = value;
    });
  }
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
      User user = User.fromJson(json.decode(response.body));

      // await setAuthToken(user.token!);
      await prefs.setAuthToken(user.token!);
      await setCurrentUser(response.body);

      return user;
    } else if (response.statusCode == 403) {
      throw FetchDataException("INVALID_PASSWORD");
    } else {
      throw FetchDataException('Failed to login');
    }
  }

  @override
  Future register(Auth user, List<String>? tagsIds) async {
    try {
      Map<String, dynamic> data = {
        "fullname": user.fullname.toString(),
        "email": user.email.toString(),
        "password": user.password.toString(),
        "acceptedTerms": true.toString(),
        "invitationCode":
            user.invitationCode == null ? "" : user.invitationCode.toString(),
        "countryCode":
            user.countryCode == null ? "" : user.countryCode.toString(),
        "dialCode": user.dialCode.toString(),
        "bio": user.bio.toString(),
        "phone": user.phone.toString(),
        "birthdate": (user.birthdate == null ? "" : user.birthdate!),
        "dailyLearningGoalInMinutes":
            user.dailyLearningGoalInMinutes.toString(),
        "addressCountryCode":
            (user.addressCountryCode == null ? "" : user.addressCountryCode!),
        "addressState": (user.addressState == null ? "" : user.addressState!),
        "addressCity": (user.addressCity == null ? "" : user.addressCity!),
        "addressLatitude":
            user.addressLatitude == null ? "" : user.addressLatitude.toString(),
        "addressLongitude": user.addressLongitude == null
            ? ""
            : user.addressLongitude.toString(),
        "tagsIds": tagsIds!.join(","),
        "registerPhase": user.registerPhase.toString(),
        "links": user.links!.length > 0 ? jsonEncode(user.links!) : null,
      };
      final jsonData;
      if (user.photoFilePath != null) {
        String fileName = user.photoFilePath!.split('/').last;
        data['file'] = await MultipartFile.fromFile(
          user.photoFilePath!,
          filename: fileName,
        );
        FormData formData = FormData.fromMap(data);
        final response = await ApiClient.api().post(
          dotenv.env['API_URL']! + "users",
          data: formData,
          options: Options(headers: {}),
        );
        if (response.statusCode != 201) {
          Sentry.captureMessage("ERROR_ON_REGISTER_1 >>> " + jsonEncode(data));
          throw Exception('Failed to create user #1');
        }
        jsonData = json.decode(response.toString());
      } else {
        final response = await ApiClient.api().post(
          dotenv.env['API_URL']! + "users",
          data: data,
        );

        if (response.statusCode != 201) {
          Sentry.captureMessage("ERROR_ON_REGISTER_2 >>> " + jsonEncode(data));
          throw Exception('Failed to create user #2');
        }
        jsonData = json.decode(response.toString());
      }
      this
          .trackingEvents
          .trackingSignupCompletedSignup(jsonData["id"], jsonData["fullname"]);
    } catch (error) {
      throw Exception('Failed to create user ' + error.toString());
    }
  }

  @override
  Future recoverPassword(String email, String lang) async {
    final response = await http.post(
      Uri.parse(dotenv.env['API_URL']! + "users/recover-password"),
      headers: API_HEADERS,
      body: jsonEncode(<String, dynamic>{"email": email, "language": lang}),
    );

    if (response.statusCode != 200) {
      Map<String, dynamic> decode = json.decode(response.body);

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

  @override
  Future<bool> emailExist(String email) async {
    try {
      final response = await http.get(
        Uri.parse(dotenv.env['API_URL']! + "users/email-exist/$email"),
        headers: API_HEADERS,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to check email exists');
      }
    } catch (error) {
      throw Exception('Failed to check email exists' + error.toString());
    }
  }
}
