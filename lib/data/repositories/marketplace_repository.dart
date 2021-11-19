import 'dart:convert';

import 'package:dio/dio.dart';
import 'dart:io';

import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/data/repositories/api.dart';

abstract class MarketplaceRepository {
  Future<List<ProductModel>> getProducts({int? limit, int? offset});
  Future<Response<dynamic>> makePurchase(
      {required String productId, required String optionalMessage});
}

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  @override
  Future<List<ProductModel>> getProducts({int? limit, int? offset}) async {
    try {
      final response = await ApiClient.api().get("market-place",
          queryParameters: {
            'limit': limit,
            'offset': offset,
            'locale': getLocale()
          });

      if (response.statusCode == 200) {
        final List<ProductModel> productList = [];
        final data = response.data;
        data.forEach((element) {
          final product = ProductModel.fromJson(element);
          productList.add(product);
        });
        return productList;
      } else {
        throw Exception('Something went wrong');
      }
    } catch (error) {
      throw Exception('Failed to load products $error');
    }
  }

  @override
  Future<Response<dynamic>> makePurchase(
      {required String productId, required String optionalMessage}) async {
    final body = jsonEncode({"message": optionalMessage});
    try {
      final response = await ApiClient.api()
          .post("market-place" + "/$productId" + "/purchase", data: body);

      return response;
    } catch (e) {
      return throw e;
    }
  }

  String getLocale() => Platform.localeName == 'pt_BR' ? 'pt-BR' : 'en';
}
