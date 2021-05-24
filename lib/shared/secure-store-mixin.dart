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

  void setTimelineVideosMuted() async {
    await this.setSecureStore("timeline_muted", "true");
  }

  void setTimelineVideosUnmuted() async {
    await this.setSecureStore("timeline_muted", "false");
  }

  void setTransferOOZToPostLimit(String limit) async {
    await this.setSecureStore("transfer_ooz_to_post_limit", limit);
  }

  void updateUserDontAskToConfirmGratitudeReward(bool value) async {
    User user = await getCurrentUser();
    user.dontAskAgainToConfirmGratitudeReward = value;
    setCurrentUser(json.encode(user.toJson()));
  }

  Future<double> getTransferOOZToPostLimit() async {
    return double.parse(
        await this.getSecureStore("transfer_ooz_to_post_limit"));
  }

  Future<bool> getTimelineVideosIsMuted() async {
    return await this.getSecureStore("timeline_muted") == "true";
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

  Future<dynamic> cleanAuthToken() async {
    await secureStore.delete(key: "user");
    await secureStore.delete(key: "auth_token");
  }
}
