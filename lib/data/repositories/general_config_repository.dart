import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:ootopia_app/data/models/general_config/general_config_model.dart';
import 'dart:convert';

import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class GeneralConfigRepository {
  Future<GeneralConfig> getConfig(String name);
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class GeneralConfigRepositoryImpl
    with SecureStoreMixin
    implements GeneralConfigRepository {
  Future<Map<String, String>> getHeaders() async {
    bool loggedIn = await getUserIsLoggedIn();
    if (!loggedIn) {
      return API_HEADERS;
    }
    String token = await getAuthToken();

    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + token
    };
  }

  Future<GeneralConfig> getConfig(String name) async {
    try {
      final response = await http.get(
        DotEnv.env['API_URL'] + "general-config/$name",
        headers: await this.getHeaders(),
      );
      if (response.statusCode == 200) {
        print("GENERAL CONFIG RESPONSE ${response.body}");
        return Future.value(GeneralConfig.fromJson(json.decode(response.body)));
      } else {
        throw Exception('Failed to load wallet');
      }
    } catch (error) {
      throw Exception('Failed to load wallet. Error: ' + error);
    }
  }
}
