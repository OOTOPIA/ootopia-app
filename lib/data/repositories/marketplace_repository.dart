import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/data/repositories/api.dart';

abstract class MarketplaceRepository {
  Future<List<ProductModel>> getProducts({int? limit, int? offset});
}

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  @override
  Future<List<ProductModel>> getProducts({int? limit, int? offset}) async {
    try {
      final response = await ApiClient.api().get("market-place",
          queryParameters: {'limit': limit, 'offset': offset});

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
}
