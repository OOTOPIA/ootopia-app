import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ootopia_app/data/models/friends/friends_data_model.dart';

import 'api.dart';

abstract class FriendsRepository {
  Future<FriendsDataModel> getFriendsWhenNotIsLogged(
      String userId, int page, int limit,
      {required String orderBy, required String sortingType});
  Future<FriendsDataModel> searchFriends(String name, int page, int limit);
  Future<bool> addFriend(String userId);
  Future<bool> removeFriend(String userId);
  Future<bool> getIfIsFriends(String userId);
}

class FriendsRepositoryImpl implements FriendsRepository {
  Future<FriendsDataModel> getFriendsWhenNotIsLogged(
      String userId, int page, int limit,
      {required String orderBy, required String sortingType}) async {
    try {
      Map<String, dynamic> queryParams = {
        "page": page,
        "limit": limit,
        "orderBy": orderBy,
        'sortingType': sortingType
      };

      final response = await ApiClient.api().get(
        dotenv.env['API_URL']! + "friends/by-user/$userId",
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        return FriendsDataModel.fromJson(response.data);
      }
      return FriendsDataModel(total: 0, friends: []);
    } catch (error) {
      print('error: $error');
      return FriendsDataModel(total: 0, friends: []);
    }
  }

  Future<FriendsDataModel> getFriendsWhenIsLogged(
      String userId, int page, int limit,
      {required String orderBy, required String sortingType}) async {
    try {
      Map<String, dynamic> queryParams = {
        "page": page,
        "limit": limit,
        "orderBy": orderBy,
        "sortingType": sortingType,
        "friendId": userId,
      };

      final response = await ApiClient.api().get(
        dotenv.env['API_URL']! + "friends/search-by-friends",
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        return FriendsDataModel.fromJson(response.data);
      }
      return FriendsDataModel(total: 0, friends: []);
    } catch (error) {
      print('error: $error');
      return FriendsDataModel(total: 0, friends: []);
    }
  }

  Future<FriendsDataModel> searchFriends(
      String name, int page, int limit) async {
    try {
      Map<String, dynamic> queryParams = {
        "page": page,
        "limit": limit,
        "name": name,
        "orderBy": 'name',
        'sortingType': 'asc'
      };

      final response = await ApiClient.api().get(
          dotenv.env['API_URL']! + "friends/search",
          queryParameters: queryParams);
      if (response.statusCode == 200) {
        return FriendsDataModel.fromJson(response.data);
      }
      return FriendsDataModel(total: 0, friends: []);
    } catch (error) {
      print('error: $error');
      return FriendsDataModel(total: 0, friends: []);
    }
  }

  Future<bool> addFriend(String userId) async {
    try {
      final response = await ApiClient.api().post(
        dotenv.env['API_URL']! + "friends/$userId",
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('error: $error');
      return false;
    }
  }

  Future<FriendsDataModel> sendContacts(
    List<String> emailContact,
    List<String> phoneContact,
    int page,
  ) async {
    try {
      final response = await ApiClient.api().post(
        dotenv.env['API_URL']! + "users/retrieve-suggested-friends",
        data: {
          'importedContactEmails': emailContact,
          'importedContactNumbers': phoneContact,
          'limit': 100,
          'page': page,
        },
      );
      if (response.statusCode == 200) {
        return FriendsDataModel.fromJson(response.data);
      } else {
        return throw Exception('Failed to load friends');
      }
    } catch (error) {
      print('error: $error');
      return throw Exception('Failed to load friends');
    }
  }

  Future<bool> removeFriend(String userId) async {
    try {
      final response = await ApiClient.api().delete(
        dotenv.env['API_URL']! + "friends/$userId",
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('error: $error');
      return false;
    }
  }

  Future<bool> getIfIsFriends(String userId) async {
    try {
      final response = await ApiClient.api().get(
        dotenv.env['API_URL']! + "friends/$userId",
      );
      if (response.statusCode == 200) {
        bool isFriend = response.data["isFriend"] ?? false;
        return isFriend;
      } else {
        return false;
      }
    } catch (error) {
      print('\nerror : $error');
      return false;
    }
  }
}
