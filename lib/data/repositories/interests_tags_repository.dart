import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'dart:convert';

import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class InterestsTagsRepository {
  Future<List<InterestsTagsModel>> getTags([String language]);
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class InterestsTagsRepositoryImpl
    with SecureStoreMixin
    implements InterestsTagsRepository {
  Future<List<InterestsTagsModel>> getTags([String? language]) async {
    try {
      Map<String, String> queryParams = {};

      if (language != null) {
        queryParams['language'] = language.replaceFirst('_', '-');
      }

      String queryString = Uri(queryParameters: queryParams).query;

      final response = await http.get(
        Uri.parse(dotenv.env['API_URL']! + "interests-tags?" + queryString),
        headers: API_HEADERS,
      );
      if (response.statusCode == 200) {
        return (json.decode(response.body) as List)
            .map((i) => InterestsTagsModel.fromJson(i))
            .toList();
      } else {
        throw Exception('Failed to load interests tags');
      }
    } catch (error) {
      throw Exception('Failed to load interests tags: ' + error.toString());
    }
  }
}
