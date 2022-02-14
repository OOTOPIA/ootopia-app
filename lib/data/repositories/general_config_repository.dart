import 'dart:convert';
import 'package:ootopia_app/data/repositories/api.dart';

import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/shared_preferences.dart';

abstract class GeneralConfigRepository {
  Future<void> getGeneralConfig();
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class GeneralConfigRepositoryImpl implements GeneralConfigRepository {
  SecureStoreMixin secureStoreMixin = SecureStoreMixin();

  Future<void> getGeneralConfig() async {
    try {
      final response = await ApiClient.api().get("general-config");
      if (response.statusCode == 200) {
        print("GENERAL CONFIG RESPONSE ${response.data}");
        await secureStoreMixin.setGeneralConfig(jsonEncode(response.data));
      } else {
        throw Exception('Failed to load general config');
      }
    } catch (error) {
      throw Exception('Failed to load general config. Error: $error');
    }
  }

  Future<void> getGlobalGoalLimitTimeInUtc() async {
    try {
      SharedPreferencesInstance prefs =
          await SharedPreferencesInstance.getInstance();

      final response = await ApiClient.api()
          .get("general-config/global_goal_limit_time_in_utc");
      if (response.statusCode == 200) {
        prefs.setGlobalGoalLimitTimeInUtc(response.data['value']);
      } else {
        throw Exception('Failed to load general config');
      }
    } catch (error) {
      throw Exception('Failed to load general config. Error: $error');
    }
  }

  Future<bool> getIosHasNotch(int iosScreenSize) async {
    bool result = false;
    try {
      final response = await ApiClient.api().get(
          'general-config/check-ios-has-notch?iosScreenSize=$iosScreenSize');
      if (response.statusCode == 200) {
        result = response.data["hasNotch"];
      } else {
        throw Exception('Failed to Validate Iphone Notch');
      }
    } catch (error) {
      throw Exception('Failed to Validate Iphone Notch. Error: $error');
    }

    return result;
  }
}
