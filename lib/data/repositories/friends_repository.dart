import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/models/wallets/wallet_transfer_model.dart';
import 'package:ootopia_app/data/models/wallets/wallet_model.dart';
import 'package:ootopia_app/data/repositories/api.dart';
import 'dart:convert';

import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/shared_preferences.dart';

abstract class FriendsRepository {
  Future<List> getFriends(String userId);
  Future<List> searchFriends(String name);
  Future<bool> addFriend(String id);
  // Future<Wallet> getFriends(String userId);

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
        Uri.parse(dotenv.env['API_URL']! + "wallets/$userId"),
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
