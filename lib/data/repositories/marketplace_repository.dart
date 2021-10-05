import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class MarketplaceRepository {
  Future<List<ProductModel>> getProducts();
  Future<Map<String, String>> getHeaders();
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class MarketplaceRepositoryImpl
    with SecureStoreMixin
    implements MarketplaceRepository {
  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse(dotenv.env['API_URL']! + "market-place"),
        headers: await getHeaders(),
      );
      if (response.statusCode == 200) {
        final List jsonList = jsonDecode(response.body);
        if (jsonList.isNotEmpty) {
          return jsonList
              .map((product) => ProductModel.fromJson(product))
              .toList();
        }
        return jsonList as List<ProductModel>;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Failed to load products $error');
    }
  }

  @override
  Future<Map<String, String>> getHeaders() async {
    bool loggedIn = await getUserIsLoggedIn();
    if (!loggedIn) {
      return API_HEADERS;
    }
    String? token = await getAuthToken();
    if (token == null) return API_HEADERS;

    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + token
    };
  }
}
