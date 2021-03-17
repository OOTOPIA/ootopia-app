import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'package:ootopia_app/data/models/profile/profile_model.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile(String id);
  //Future<TimelinePost> getPost(int id);
  //Future<TimelinePost> updatePost(post);
  //Future<TimelinePost> deletePost(int id);
  //Future<TimelinePost> createPost(post);
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class ProfileRepositoryImpl with SecureStoreMixin implements ProfileRepository {
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

  Future<ProfileModel> getProfile(id) async {
    try {
      final response = await http.get(
        DotEnv.env['API_URL'] + "users/$id/profile",
        headers: await this.getHeaders(),
      );
      if (response.statusCode == 200) {
        print("POSTS RESPONSE ${response.body}");
        ProfileModel profile =
            ProfileModel.fromJson(json.decode(response.body));
        return profile;
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (error) {
      throw Exception('Failed to load profile' + error);
    }
  }
}
