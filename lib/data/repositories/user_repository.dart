import 'dart:convert';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'package:ootopia_app/data/models/users/profile_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:path/path.dart';

abstract class UserRepository {
  Future<Profile> getProfile(String id);
  Future<String> updateUser(User user, FlutterUploader uploader);
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class UserRepositoryImpl with SecureStoreMixin implements UserRepository {
  Future<Map<String, String>> getHeaders() async {
    bool loggedIn = await getUserIsLoggedIn();
    if (!loggedIn) {
      return API_HEADERS;
    }
    String token = await getAuthToken();

    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + token
    };
  }

  Future<Profile> getProfile(id) async {
    try {
      final response = await http.get(
        DotEnv.env['API_URL'] + "users/$id/profile",
        headers: await this.getHeaders(),
      );
      if (response.statusCode == 200) {
        print("PROFILE LOADED ${response.body}");
        Profile profile = Profile.fromJson(json.decode(response.body));
        return Future.value(profile);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (error) {
      throw Exception('Failed to load profile' + error);
    }
  }

  @override
  Future<String> updateUser(User user, FlutterUploader uploader) async {
    try {
      Map<String, String> data = {
        "birthdate": user.birthdate,
        "dailyLearningGoalInMinutes":
            user.dailyLearningGoalInMinutes.toString(),
        "addressCountryCode": user.addressCountryCode,
        "addressState": user.addressState,
        "addressCity": user.addressCity,
        "addressLatitude": user.addressLatitude.toString(),
        "addressLongitude": user.addressLongitude.toString(),
      };

      return await uploader.enqueue(
        url: DotEnv.env['API_URL'] + "users/${user.id}",
        files: [
          FileItem(
            filename: basename(user.photoFilePath),
            savedDir: dirname(user.photoFilePath),
            fieldname: "file",
          )
        ], // required: list of files that you want to upload
        method: UploadMethod.PUT, // HTTP method  (POST or PUT or PATCH)
        headers: await this.getHeaders(),
        data: data, // any data you want to send in upload request
        showNotification:
            false, // send local notification (android only) for upload status
        tag: "Uploading user photo",
      );
    } catch (error) {
      throw Exception('Failed to create post ' + error);
    }
  }
}
