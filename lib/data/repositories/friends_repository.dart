import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:ootopia_app/data/models/friends/friend_model.dart';
import 'package:ootopia_app/data/models/friends/friends_data_model.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/shared_preferences.dart';

import 'api.dart';

abstract class FriendsRepository {
  Future<FriendsDataModel> getFriends(String userId, int page, int limit);
  Future<List> searchFriends(String name, int page, int limit);
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

  Future<FriendsDataModel> getFriends(String userId, int page, int limit) async {
    try {
      Map<String, int> queryParams = {
        "page": page,
        "limit" : limit,
      };

      final response = await ApiClient.api().get(
        dotenv.env['API_URL']! + "friends/$userId",
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        return FriendsDataModel.fromJson(response.data);
      }
      return   FriendsDataModel(total: 0, friends: []);
    } catch (error) {
      print('error: $error');
      return   FriendsDataModel(total: 0, friends: []);
    }
  }

  Future<List<FriendModel>> searchFriends(String name, int page, int limit) async {
    try {
      Map<String, dynamic> queryParams = {
        "page": page,
        "limit" : limit,
        "name": name,
        "orderBy": 'name',
        'sortingType' : 'asc'
      };

      final response = await ApiClient.api().get(
        dotenv.env['API_URL']! + "friends/search",
        queryParameters: queryParams
      );
      if (response.statusCode == 200) {
        return (response.data as List).map((i) => FriendModel.fromJson(i)).toList();
      }
      return [];
    } catch (error) {
      print('error: $error');
      return   [];
    }
  }

  Future<bool> addFriend(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(dotenv.env['API_URL']! + "friends/$userId"),
        headers: await this.getHeaders(),
      );
      if (response.statusCode == 201) {
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
