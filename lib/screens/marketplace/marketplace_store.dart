import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';

part 'marketplace_store.g.dart';

class MarketplaceStore = MarketplaceStoreBase with _$MarketplaceStore;

abstract class MarketplaceStoreBase with Store {
  @observable
  ObservableList<ProductModel> productList = ObservableList();
}
