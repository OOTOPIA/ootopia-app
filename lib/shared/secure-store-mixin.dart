import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'dart:convert';

class SecureStoreMixin {
  final secureStore = new FlutterSecureStorage();

  Future<bool> setCurrentUser(String json) async {
    await this.setSecureStore("user", json);
    return true;
  }

  Future<bool> setAuthToken(String value) async {
    await this.setSecureStore("auth_token", value);
    return true;
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

  void setRecoverPasswordToken(String value) async {
    await this.setSecureStore("recover_password_token", value);
  }

  Future<String> getRecoverPasswordToken() async {
    return await this.getSecureStore("recover_password_token");
  }

  Future<double> getTransferOOZToPostLimit() async {
    return double.parse(
        await this.getSecureStore("transfer_ooz_to_post_limit"));
  }

  Future<bool> getTimelineVideosIsMuted() async {
    return await this.getSecureStore("timeline_muted") == "true";
  }

  Future<bool> getUserIsLoggedIn() async {
    String? token = await this.getAuthToken();
    return token != null;
  }

  Future<String?> getAuthToken() async {
    return await this.getSecureStore("auth_token");
  }

  Future<User> getCurrentUser() async {
    return User.fromJson(json.decode(await this.getSecureStore("user")));
  }

  Future<bool> setSecureStore(String key, String data) async {
    await secureStore.write(key: key, value: data);
    return true;
  }

  Future<dynamic> getSecureStore(String key) async {
    return await secureStore.read(key: key);
  }

  Future<dynamic> cleanAuthToken() async {
    await secureStore.delete(key: "user");
    await secureStore.delete(key: "auth_token");
  }
}
