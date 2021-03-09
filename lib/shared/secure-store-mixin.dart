import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'dart:convert';

class SecureStoreMixin {
  final secureStore = new FlutterSecureStorage();

  void setCurrentUser(String json) async {
    await this.setSecureStore("user", json);
  }

  void setAuthToken(String value) async {
    await this.setSecureStore("auth_token", value);
  }

  Future<bool> getUserIsLoggedIn() async {
    String token = await this.getAuthToken();
    return token != null;
  }

  Future<String> getAuthToken() async {
    return await this.getSecureStore("auth_token");
  }

  Future<User> getCurrentUser() async {
    return User.fromJson(json.decode(await this.getSecureStore("user")));
  }

  void setSecureStore(String key, String data) async {
    await secureStore.write(key: key, value: data);
  }

  Future<dynamic> getSecureStore(String key) async {
    return await secureStore.read(key: key);
  }
}
