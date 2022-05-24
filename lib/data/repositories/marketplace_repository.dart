import 'dart:convert';

import 'package:dio/dio.dart';
import 'dart:io';

import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/data/repositories/api.dart';

abstract class MarketplaceRepository {
  Future<List<ProductModel>> getProducts({int? limit, int? offset});
  Future<Response<dynamic>> makePurchase(
      {required String productId, required String optionalMessage});
  Future<ProductModel> getProductById(String id);
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
  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await ApiClient.api().get("market-place/$id");

      if (response.statusCode == 200) {
        final ProductModel product;
        product = ProductModel.fromJson(response.data);
        return product;
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

  Future<bool> deleteProduct(String id) async {
    try {
      var response = await ApiClient.api().delete("users/$id");
      return response.statusCode == 200;
    } catch (e) {
      if (e is DioError) {
        print('${e.error} ${e.response} ${e.message}');
      }
      throw Exception('Failed to delete product, please try again');
    }
  }

  String getLocale() => Platform.localeName == 'pt_BR' ? 'pt-BR' : 'en';
}
