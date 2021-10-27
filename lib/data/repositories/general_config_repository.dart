import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ootopia_app/data/models/general_config/general_config_model.dart';
import 'package:ootopia_app/data/repositories/api.dart';
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
  Future<GeneralConfig> getConfig(String name) async {
    try {
      final response = await ApiClient.api().get("general-config/$name");
      if (response.statusCode == 200) {
        print("GENERAL CONFIG RESPONSE ${response.data}");
        return Future.value(GeneralConfig.fromJson(response.data));
      } else {
        throw Exception('Failed to load wallet');
      }
    } catch (error) {
      throw Exception('Failed to load wallet. Error: $error');
    }
  }
}
