import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ootopia_app/data/models/friends/friend_model.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/shared_preferences.dart';

abstract class FriendsRepository {
  Future<List> getFriends(String userId);
  Future<List> searchFriends(String name);
  Future<bool> addFriend(String id);
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

  Future<List> getFriends(String userId) async {
    try {
      final response = await http.get(
        Uri.parse(dotenv.env['API_URL']! + "friends-request/$userId"),
        headers: await this.getHeaders(),
      );
      print('response.body : ${response.body}');
      if (response.statusCode == 200) {
        print('response.body : ${response.body}');
        return (json.decode(response.body) as List).map((i) => FriendModel.fromJson(i)).toList();
      } else {
        throw Future.error('Failed to load wallet');
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

  Future<bool> addFriend(String name) async {
    try {
      final response = await http.get(
        Uri.parse(dotenv.env['API_URL']! + "wallets/$name"),
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
