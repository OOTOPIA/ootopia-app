import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ootopia_app/data/models/users/auth_model.dart';
import 'dart:convert';

import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/utils/fetch-data-exception.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(
      Auth user, List<String>? tagsIds, FlutterUploader? uploader);
  Future recoverPassword(String email, String lang);
  Future resetPassword(String newPassword);
  Future<bool> emailExist(String email);
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
  Future<User> register(
      Auth user, List<String>? tagsIds, FlutterUploader? uploader) async {
    // print("REGISTER RESPONSE BODY ${response.body}");
    try {
      Map<String, String> data = {
        "fullname": user.fullname.toString(),
        "email": user.email.toString(),
        "password": user.password.toString(),
        "acceptedTerms": true.toString(),
        "invitationCode":
            user.invitationCode == null ? "" : user.invitationCode.toString(),
        "countryCode":
            user.countryCode == null ? "" : user.countryCode.toString(),
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
        "tagsIds": tagsIds!.join(",")
      };

      //   final response = await http.post(
      //   Uri.parse(dotenv.env['API_URL']! + "users"),
      //   headers: API_HEADERS,
      //   body: jsonEncode(<String, dynamic>{
      //     "fullname": user.fullname,
      //     "email": user.email,
      //     "password": user.password,
      //     "invitationCode": user.invitationCode,
      //     "acceptedTerms": true,
      //   }),
      // );

      if (user.photoFilePath != null && uploader != null) {
        var result = await uploader.enqueue(
          MultipartFormDataUpload(
            url: dotenv.env['API_URL']! + "users",
            files: [
              FileItem(
                path: user.photoFilePath!,
                field: "file",
              )
            ], // required: list of files that you want to upload
            method: UploadMethod.POST, // HTTP method  (POST or PUT or PATCH)
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            data: data, // any data you want to send in upload request
            tag: "Uploading user photo",
          ),
        );

        await setCurrentUser(jsonEncode(user.toJson()));
        return User(
          fullname: '',
          bio: '',
          email: '',
          birthdate: '',
          id: '',
          addressCity: '',
          addressCountryCode: '',
          addressLatitude: 0,
          addressLongitude: 0,
          badges: [],
          addressState: '',
        );
      } else {
        final response = await http.post(
          Uri.parse(
            dotenv.env['API_URL']! + "users",
          ),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(data),
        );

        if (response.statusCode == 201) {
          await setCurrentUser(response.body);
          return User.fromJson(json.decode(response.body));
        } else {
          throw Exception('Failed to update user');
        }
      }
    } catch (error) {
      print('$error');
      throw Exception('Failed to update user ' + error.toString());
    }

    // if (response.statusCode == 201) {
    //   // await this.login( user.email as String, user.password as String);
    //   User user = User.fromJson(json.decode(response.body));
    //   return user;
    // } else {
    //   Map<String, dynamic> decode = json.decode(response.body);
    //   switch (decode['error']) {
    //     case 'Invitation Code invalid':
    //       throw FetchDataException(decode['error']);
    //     case 'EMAIL_ALREADY_EXISTS':
    //       throw FetchDataException(decode['error']);
    //     default:
    //       throw FetchDataException('Failed to register');
    //   }
    // }
  }

  @override
  Future recoverPassword(String email, String lang) async {
    final response = await http.post(
      Uri.parse(dotenv.env['API_URL']! + "users/recover-password"),
      headers: API_HEADERS,
      body: jsonEncode(<String, dynamic>{"email": email, "language": lang}),
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
