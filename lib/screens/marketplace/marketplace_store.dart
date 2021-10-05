import 'dart:convert';

import 'package:mobx/mobx.dart';

import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/marketplace_repository.dart';

part 'marketplace_store.g.dart';

class MarketplaceStore = MarketplaceStoreBase with _$MarketplaceStore;

enum ViewState { loading, error, done }

abstract class MarketplaceStoreBase with Store {
  final _marketplaceRepository = MarketplaceRepositoryImpl();

  @observable
  ViewState viewState = ViewState.loading;

  @observable
  ObservableList<ProductModel> productList = ObservableList();

  @action
  Future<void> getProductList() async {
    try {
      final List<ProductModel> products =
          await _marketplaceRepository.getProducts();
      productList.addAll(products);
      viewState = ViewState.done;
    } catch (error) {
      viewState = ViewState.error;
    }
  }
}

final list = <ProductModel>[
  ProductModel.fromJson(jsonDecode(productJson)),
  ProductModel.fromJson(jsonDecode(productJson)),
];

final productJson = '''{
    "id": 0,
    "title": "string",
    "description": "string",
    "photoUrl": "string",
    "price": 0,
    "userName": "string",
    "userEmail": "string",
    "userPhotoUrl": "string",
    "userPhoneNumber": "string",
    "userLocation": "string"
  }''';
