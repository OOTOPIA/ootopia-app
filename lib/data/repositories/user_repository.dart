import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ootopia_app/data/models/users/daily_goal_stats_model.dart';
import 'package:ootopia_app/data/models/users/invitation_code_model.dart';

import 'package:ootopia_app/data/models/users/profile_model.dart';
import 'package:ootopia_app/data/models/users/user_comment.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/api.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/shared_preferences.dart';

abstract class UserRepository {
  Future<Profile> getProfile(String id);
  Future<User> getMyAccountDetails();
  Future<User> updateUser(User user, List<String> tagsIds);
  Future updateUserProfile(
      User user, List<String> tagsIds, FlutterUploader? uploader);
  Future recordTimeUserUsedApp(int timeInMilliseconds);
  Future<DailyGoalStatsModel?> getDailyGoalStats();
  Future<List<InvitationCodeModel>?> getCodes();
  Future<String> verifyCodes(String code);
  Future updateTokenDeviceUser(String tokenDevice);
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class UserRepositoryImpl with SecureStoreMixin implements UserRepository {
  Future<Map<String, String>> getHeaders([String? contentType]) async {
    SharedPreferencesInstance prefs =
        await SharedPreferencesInstance.getInstance();
    bool loggedIn = await getUserIsLoggedIn();
    if (!loggedIn) {
      return API_HEADERS;
    }

    String? token = prefs.getAuthToken();
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
        "bio": user.bio.toString(),
        "phone": user.phone.toString(),
        "fullname": user.fullname.toString(),
        "countryCode": user.countryCode.toString(),
        "tagsIds": tagsIds.join(",")
      };

      if (user.photoFilePath != null) {
        var response = await FlutterUploader().enqueue(
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
        await setCurrentUser(jsonEncode(user.toJson()));
        return user;
      } else {
        final response = await http.put(
          Uri.parse(dotenv.env['API_URL']! + "users/${user.id}"),
          headers: await this.getHeaders(),
          body: jsonEncode(data),
        );
        if (response.statusCode == 200) {
          await setCurrentUser(response.body);
          return User.fromJson(json.decode(response.body));
        } else {
          throw Exception('Failed to update user');
        }
      }
    } catch (error) {
      throw Exception('Failed to update user ' + error.toString());
    }
  }

  @override
  Future updateTokenDeviceUser(String? deviceToken) async {
    try {
      String? deviceId;
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

      try {
        if (Platform.isAndroid) {
          deviceId = (await deviceInfoPlugin.androidInfo).androidId;
        } else if (Platform.isIOS) {
          deviceId = (await deviceInfoPlugin.iosInfo).identifierForVendor;
        }
      } catch (error) {
        print("ERROR !updateTokenDeviceUser $error");
        return;
      }

      if (deviceId == null) return;

      final response = await http.put(
        Uri.parse(dotenv.env['API_URL']! + "users-device-token"),
        headers: await this.getHeaders(),
        body: jsonEncode({
          'deviceToken': deviceToken,
          'deviceId': deviceId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update token device user');
      }
    } catch (error) {
      throw Exception('Failed to update token device user ' + error.toString());
    }
  }

  //Este método foi criado pois o risco de alterar o método updateUser é maior devido ao seu uso atual
  //Dessa forma, preferi criar outro para resolver o problema de atualizar o perfil
  @override
  Future updateUserProfile(
      User user, List<String> tagsIds, FlutterUploader? uploader) async {
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
        "bio": user.bio.toString(),
        "phone": user.phone.toString(),
        "fullname": user.fullname.toString(),
        "countryCode": user.countryCode.toString(),
        "dialCode": user.dialCode.toString(),
        "tagsIds": tagsIds.join(","),
        "links": user.links!.length > 0 ? jsonEncode(user.links!) : '',
      };

      if (user.photoFilePath != null && uploader != null) {
        var result = await uploader.enqueue(
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
        await setCurrentUser(user.toJson().toString());
        return result;
      } else {
        final response = await http.put(
          Uri.parse(dotenv.env['API_URL']! + "users/${user.id}"),
          headers: await this.getHeaders(),
          body: jsonEncode(data),
        );
        if (response.statusCode == 200) {
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
  }

  @override
  Future recordTimeUserUsedApp(int timeInMilliseconds) async {
    SharedPreferencesInstance prefs =
        await SharedPreferencesInstance.getInstance();

    bool loggedIn = prefs.getAuthToken() != null;
    if (!loggedIn || timeInMilliseconds <= 0) {
      return;
    }

    await ApiClient.api().post(
      "users/usage-time",
      data: {
        "timeInMilliseconds": timeInMilliseconds,
      },
    );
  }

  @override
  Future updateUserRegenerarionGameLearningAlert(String type) async {
    bool loggedIn = await getUserIsLoggedIn();
    if (!loggedIn) {
      return;
    }

    User user = (await getCurrentUser())!;

    await ApiClient.api().put(
      "users/${user.id}/dialog-opened/$type",
    );
  }

  @override
  Future<DailyGoalStatsModel?> getDailyGoalStats() async {
    try {
      bool loggedIn = await getUserIsLoggedIn();
      if (!loggedIn) {
        return null;
      }
      User user = (await getCurrentUser())!;

      Response res = await ApiClient.api().get(
        "users/${user.id}/daily-goal-stats",
      );
      if (res.statusCode != 200) {
        throw Exception(res.data);
      }
      var result = DailyGoalStatsModel.fromJson(res.data);
      return result;
    } catch (e) {
      throw Exception('Failed to get daily goal stats ' + e.toString());
    }
  }

  @override
  Future<List<InvitationCodeModel>?> getCodes() async {
    try {
      bool loggedIn = await getUserIsLoggedIn();
      if (!loggedIn) {
        return null;
      }
      User user = (await getCurrentUser())!;

      Response res = await ApiClient.api().get(
        "users/${user.id}/invitation-code",
      );
      if (res.statusCode != 200) {
        throw Exception(res.data);
      }

      var result = (res.data as List)
          .map((e) => InvitationCodeModel.fromJson(e))
          .toList();
      return result;
    } catch (e) {
      throw Exception('Failed to get codes ' + e.toString());
    }
  }

  @override
  Future<String> verifyCodes(String code) async {
    try {
      if (code.isEmpty) return "";
      Response res = await ApiClient.api().get(
        "users/invitation-code/$code",
      );
      if (res.statusCode != 200) {
        throw Exception(res.data);
      }
      return res.data['status'];
    } catch (e) {
      throw Exception('Code invalid ' + e.toString());
    }
  }

  Future<List<UserSearchModel>> getAllUsersByName(
      String fullName, int page, int limit) async {
    try {
      Response res = await ApiClient.api().get(
        "users/search",
        queryParameters: {
          'page': page,
          'limit': limit,
          'fullname': fullName,
        },
      );
      if (res.statusCode != 200) {
        throw Exception(res.data);
      }
      return (res.data as List)
          .map((e) => UserSearchModel.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Name user not valid');
    }
  }
}
