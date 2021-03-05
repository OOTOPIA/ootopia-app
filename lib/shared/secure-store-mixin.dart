import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStoreMixin {
  final secureStore = new FlutterSecureStorage();

  void setUserFullname(String value) async {
    await this.setSecureStore("user_fullname", value);
  }

  void setUserPhotoUrl(String value) async {
    await this.setSecureStore("user_photo_url", value);
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

  void setSecureStore(String key, String data) async {
    await secureStore.write(key: key, value: data);
  }

  Future<dynamic> getSecureStore(String key) async {
    return await secureStore.read(key: key);
  }
}
