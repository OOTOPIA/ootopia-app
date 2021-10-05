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
      productList.addAll(list);
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
    "title": "What is Lorem Ipsum?",
    "description": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
    "photoUrl": "https://images.pexels.com/photos/357514/pexels-photo-357514.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
    "price": 100,
    "userName": "Caio Vinicius",
    "userEmail": "caio.jesus@devmagic.com.br",
    "userPhotoUrl": "https://reqres.in/img/faces/2-image.jpg",
    "userPhoneNumber": "string",
    "userLocation": "Aracaju Sergipe"
  }''';
