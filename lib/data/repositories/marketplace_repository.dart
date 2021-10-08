import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ootopia_app/data/repositories/api.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class IMarketplaceRepository {
  Future<Response<dynamic>> makePurchase(
      {required String productId, required String optionalMessage});
}

class MarketplaceRepositoryImpl
    with SecureStoreMixin
    implements IMarketplaceRepository {
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
}
