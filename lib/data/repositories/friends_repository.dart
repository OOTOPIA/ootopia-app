import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:ootopia_app/data/models/friends/friend_model.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/shared_preferences.dart';

import 'api.dart';

abstract class FriendsRepository {
  Future<List> getFriends(String userId, int page, int limit);
  Future<List> searchFriends(String name);
  Future<bool> addFriend(String userId);
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class FriendsRepositoryImpl with SecureStoreMixin implements FriendsRepository {
  Future<Map<String, String>> getHeaders() async {
    SharedPreferencesInstance prefs =
    await SharedPreferencesInstance.getInstance();
    bool loggedIn = await getUserIsLoggedIn();
    if (!loggedIn) {
      return API_HEADERS;
    }

    String? token = prefs.getAuthToken();
    if (token == null) return API_HEADERS;

    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + token
    };
  }

  Future<List<FriendModel>> getFriends(String userId, int page, int limit) async {
    try {
      Map<String, int> queryParams = {
        "page": page,
        "limit" : limit,
      };

      final response = await ApiClient.api().get(
        dotenv.env['API_URL']! + "friends-request/$userId",
        queryParameters: queryParams,
      );
      log('response.body : ${response.data}');
      if (response.statusCode == 200) {
        print('response.body : ${response.data}');
        return (json.decode(response.data) as List).map((i) => FriendModel.fromJson(i)).toList();
      } else {
        throw Future.error('error: status code != 200 ${response.statusCode}');
      }
    } catch (error) {
      print('error: $error');
      return   [];
    }
  }

  Future<List> searchFriends(String name) async {
    try {
      final response = await http.get(
        Uri.parse(dotenv.env['API_URL']! + "wallets/$name"),
        headers: await this.getHeaders(),
      );
      if (response.statusCode == 200) {
        return  [];
      } else {
        throw Future.error('Failed to load wallet');
      }
    } catch (error) {
      print('error: $error');
      return   [];
    }
  }

  Future<bool> addFriend(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(dotenv.env['API_URL']! + "friends-request/$userId"),
        headers: await this.getHeaders(),
      );
      if (response.statusCode == 200) {
        return  true;
      } else {
        print('response.statusCode: ${response.statusCode}');
        return  false;
      }
    } catch (error) {
      print('error: $error');
      return  false;
    }
  }


}
