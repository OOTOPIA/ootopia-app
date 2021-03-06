import 'dart:convert';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:ootopia_app/data/models/users/profile_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class UserRepository {
  Future<Profile> getProfile(String id);
  Future<User> getMyAccountDetails();
  Future<User> updateUser(User user, List<String> tagsIds);
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class UserRepositoryImpl with SecureStoreMixin implements UserRepository {
  Future<Map<String, String>> getHeaders([String? contentType]) async {
    bool loggedIn = await getUserIsLoggedIn();
    if (!loggedIn) {
      return API_HEADERS;
    }

    String? token = await getAuthToken();
    if (token == null) return API_HEADERS;

    Map<String, String> headers = {'Authorization': 'Bearer ' + token};

    if (contentType == null) {
      headers['Content-Type'] = 'application/json; charset=UTF-8';
    }

    return headers;
  }

  Future<User> getMyAccountDetails() async {
    try {
      final response = await http.get(
        Uri.parse(dotenv.env['API_URL']! + "users/"),
        headers: await this.getHeaders(),
      );
      if (response.statusCode == 200) {
        print("USER ACCOUNT ${response.body}");
        await setCurrentUser(response.body);
        User user = User.fromJson(json.decode(response.body));
        return Future.value(user);
      } else {
        throw Exception('Failed to load user account details');
      }
    } catch (error, s) {
      throw Exception('Failed to load user account details: $s');
    }
  }

  Future<Profile> getProfile(id) async {
    try {
      final response = await http.get(
        Uri.parse(dotenv.env['API_URL']! + "users/$id/profile"),
        headers: await this.getHeaders(),
      );
      if (response.statusCode == 200) {
        print("PROFILE LOADED ${response.body}");
        Profile profile = Profile.fromJson(json.decode(response.body));
        return Future.value(profile);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (error, s) {
      throw Exception('Failed to load profile $s');
    }
  }

  @override
  Future<User> updateUser(User user, List<String> tagsIds) async {
    try {
      Map<String, String> data = {
        "birthdate": (user.birthdate == null ? "" : user.birthdate!),
        "dailyLearningGoalInMinutes":
            user.dailyLearningGoalInMinutes.toString(),
        "addressCountryCode":
            (user.addressCountryCode == null ? "" : user.addressCountryCode!),
        "addressState": (user.addressState == null ? "" : user.addressState!),
        "addressCity": (user.addressCity == null ? "" : user.addressCity!),
        "addressLatitude": user.addressLatitude.toString(),
        "addressLongitude": user.addressLongitude.toString(),
        "tagsIds": tagsIds.join(",")
      };

      if (user.photoFilePath != null) {
        await FlutterUploader().enqueue(
          MultipartFormDataUpload(
            url: dotenv.env['API_URL']! + "users/${user.id}",
            files: [
              FileItem(
                path: user.photoFilePath!,
                field: "file",
              )
            ], // required: list of files that you want to upload
            method: UploadMethod.PUT, // HTTP method  (POST or PUT or PATCH)
            headers: await this.getHeaders("multipart/form-data"),
            data: data, // any data you want to send in upload request
            tag: "Uploading user photo",
          ),
        );
        return user;
      } else {
        final response = await http.put(
          Uri.parse(dotenv.env['API_URL']! + "users/${user.id}"),
          headers: await this.getHeaders(),
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          return User.fromJson(json.decode(response.body));
        } else {
          throw Exception('Failed to update user');
        }
      }
    } catch (error) {
      throw Exception('Failed to update user ' + error.toString());
    }
  }
}
