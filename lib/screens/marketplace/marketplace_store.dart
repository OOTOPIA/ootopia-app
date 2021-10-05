import 'package:mobx/mobx.dart';

import 'package:ootopia_app/data/models/marketplace/product_model.dart';
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
    final List<ProductModel> response =
        await _marketplaceRepository.getProducts(limit: 3);
    productList.addAll(response);
    viewState = ViewState.done;
  }
}
