import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static StorageUtil storageInstance = StorageUtil._instance();
  static SharedPreferences? _preferences;

  StorageUtil._instance() {
    getPreferences();
  }
  void getPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  void setIsShowSplashScreen({required bool value, required String key}) {
    _preferences?.setBool(key, value);
  }

  bool? getIsShowSplashScreen(String key) {
    return _preferences?.getBool(key);
  }
}
