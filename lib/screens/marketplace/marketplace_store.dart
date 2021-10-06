import 'package:mobx/mobx.dart';

import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/data/repositories/marketplace_repository.dart';

part 'marketplace_store.g.dart';

class MarketplaceStore = MarketplaceStoreBase with _$MarketplaceStore;

enum ViewState { loading, error, done }

abstract class MarketplaceStoreBase with Store {
  final _marketplaceRepository = MarketplaceRepositoryImpl();

  final int itemsPerPageCount = 5;

  @observable
  int currentPage = 1;

  @observable
  ViewState viewState = ViewState.loading;

  @observable
  ObservableList<ProductModel> productList = ObservableList();

  @observable
  var hasMoreItems = true;

  @action
  Future<void> getProductList({int? limit, int? offset}) async {
    final List<ProductModel> response =
        await _marketplaceRepository.getProducts(limit: limit, offset: offset);
    productList.addAll(response);
    print(productList.length);
    viewState = ViewState.done;
  }

  @action
  Future<void> getData() async {
    viewState = ViewState.loading;
    await getProductList(
      limit: itemsPerPageCount,
      offset: productList.length - 1,
    );
    hasMoreItems = productList.length == itemsPerPageCount;
  }
}
