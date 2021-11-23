import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ootopia_app/data/models/general_config/general_config_model.dart';
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

  Future<bool> setGeneralConfig(String value) async {
    await this.setSecureStore("general_config", value);
    return true;
  }

  void setTimelineVideosMuted() async {
    await this.setSecureStore("timeline_muted", "true");
  }

  void setTimelineVideosUnmuted() async {
    await this.setSecureStore("timeline_muted", "false");
  }

  void setTransferOOZToPostLimit(double limit) async {
    await this.setSecureStore("transfer_ooz_to_post_limit", limit.toString());
  }

  void updateUserDontAskToConfirmGratitudeReward(bool value) async {
    User? user = await getCurrentUser();
    user?.dontAskAgainToConfirmGratitudeReward = value;
    if (user != null) {
      setCurrentUser(json.encode(user.toJson()));
    }
  }

  updateUserRegenerarionGameLearningAlert(String type) async {
    User? user = await getCurrentUser();

    switch (type) {
      case "personal":
        user?.personalDialogOpened = true;

        break;

      case "city":
        user?.cityDialogOpened = true;

        break;

      case "global":
        user?.globalDialogOpened = true;

        break;
    }
    if (user != null) {
      await setCurrentUser(json.encode(user.toJson()));
    }
  }

  void setRecoverPasswordToken(String value) async {
    await this.setSecureStore("recover_password_token", value);
  }

  Future<String> getRecoverPasswordToken() async {
    return await this.getSecureStore("recover_password_token");
  }

  Future<List<GeneralConfigModel>> getGeneralConfig() async {
    var generalConfigJSON = await this.getSecureStore("general_config");

    return (jsonDecode(generalConfigJSON) as List)
        .map((e) => GeneralConfigModel.fromJson(e))
        .toList();
  }

  Future<GeneralConfigModel> getGeneralConfigByName(String name) async {
    List<GeneralConfigModel> generalConfigModel = await getGeneralConfig();
    return generalConfigModel.firstWhere((element) => element.name == name);
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

  Future<User?> getCurrentUser() async {
    var userStorage = await this.getSecureStore("user");
    if (userStorage == null) {
      return null;
    }
    return User.fromJson(json.decode(userStorage));
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
