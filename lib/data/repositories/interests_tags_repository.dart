import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'dart:convert';

import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class InterestsTagsRepository {
  Future<List<InterestsTags>> getTags([String language]);
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class InterestsTagsRepositoryImpl
    with SecureStoreMixin
    implements InterestsTagsRepository {
  Future<List<InterestsTags>> getTags([String language]) async {
    try {
      Map<String, String> queryParams = {};

      if (language != null) {
        queryParams['language'] = language;
      }

      String queryString = Uri(queryParameters: queryParams).query;

      final response = await http.get(
        DotEnv.env['API_URL'] + "interests-tags?" + queryString,
        headers: API_HEADERS,
      );
      if (response.statusCode == 200) {
        print("INTERESTS TAGS RESPONSE ${response.body}");
        return (json.decode(response.body) as List)
            .map((i) => InterestsTags.fromJson(i))
            .toList();
      } else {
        throw Exception('Failed to load interests tags');
      }
    } catch (error) {
      throw Exception('Failed to load interests tags: ' + error.toString());
    }
  }
}
