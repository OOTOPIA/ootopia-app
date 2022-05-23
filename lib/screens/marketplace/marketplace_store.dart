import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/data/repositories/marketplace_repository.dart';

part 'marketplace_store.g.dart';

class MarketplaceStore = MarketplaceStoreBase with _$MarketplaceStore;

enum ViewState { loading, error, done, loadingMoreProducts }

abstract class MarketplaceStoreBase with Store {
  final _marketplaceRepository = MarketplaceRepositoryImpl();

  final int itemsPerPageCount = 12;
  int currentPage = 0;

  @observable
  ViewState viewState = ViewState.loading;

  @observable
  ObservableList<ProductModel> productList = ObservableList();

  @observable
  bool hasMoreItems = true;

  final currencyFormatter = NumberFormat('#,##0.00', 'ID');

  @action
  Future<void> getProducts({bool clearList = false}) async {
    try {
      final List<ProductModel> response = await _marketplaceRepository
          .getProducts(limit: itemsPerPageCount, offset: currentPage*itemsPerPageCount);
      hasMoreItems = response.length == itemsPerPageCount;
      if(clearList){
        productList.clear();
      }
      productList.addAll(response);
      viewState = ViewState.done;
    } catch (error) {
      viewState = ViewState.error;
    }
  }

  @action
  Future<void> getMoreProducts() async {
    viewState = ViewState.loadingMoreProducts;
    currentPage++;
    await getProducts();
  }

  @action
  Future<void> refreshData() async {
    currentPage = 0;
    await getProducts(clearList: true);
  }

  bool loadingPage(){
    return viewState == ViewState.loading;
  }

  bool loadingMoreItems(){
    return viewState == ViewState.loadingMoreProducts;
  }

  bool canLoadMoreProducts(){
    return viewState == ViewState.done && hasMoreItems;
  }


}
