import 'dart:convert';

import 'package:ootopia_app/data/repositories/api.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class IMarketplaceRepository {
  Future<bool> makePurchase(
      {required String productId, required String optionalMessage});
}

class MarketplaceRepositoryImpl
    with SecureStoreMixin
    implements IMarketplaceRepository {
  @override
  Future<bool> makePurchase(
      {required String productId, required String optionalMessage}) async {
    final body = jsonEncode({"message": optionalMessage});
    try {
      final response = await ApiClient.api()
          .post("market-place" + "/$productId" + "/purchase", data: body);

      return response.statusCode == 201;
    } catch (e) {
      return throw Exception('failed to make purchase $e');
    }
  }
}
