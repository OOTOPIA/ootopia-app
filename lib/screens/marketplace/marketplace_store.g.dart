// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MarketplaceStore on MarketplaceStoreBase, Store {
  final _$currentPageAtom = Atom(name: 'MarketplaceStoreBase.currentPage');

  @override
  int get currentPage {
    _$currentPageAtom.reportRead();
    return super.currentPage;
  }

  @override
  set currentPage(int value) {
    _$currentPageAtom.reportWrite(value, super.currentPage, () {
      super.currentPage = value;
    });
  }

  final _$viewStateAtom = Atom(name: 'MarketplaceStoreBase.viewState');

  @override
  ViewState get viewState {
    _$viewStateAtom.reportRead();
    return super.viewState;
  }

  @override
  set viewState(ViewState value) {
    _$viewStateAtom.reportWrite(value, super.viewState, () {
      super.viewState = value;
    });
  }

  final _$productListAtom = Atom(name: 'MarketplaceStoreBase.productList');

  @override
  ObservableList<ProductModel> get productList {
    _$productListAtom.reportRead();
    return super.productList;
  }

  @override
  set productList(ObservableList<ProductModel> value) {
    _$productListAtom.reportWrite(value, super.productList, () {
      super.productList = value;
    });
  }

  final _$hasMoreItemsAtom = Atom(name: 'MarketplaceStoreBase.hasMoreItems');

  @override
  bool get hasMoreItems {
    _$hasMoreItemsAtom.reportRead();
    return super.hasMoreItems;
  }

  @override
  set hasMoreItems(bool value) {
    _$hasMoreItemsAtom.reportWrite(value, super.hasMoreItems, () {
      super.hasMoreItems = value;
    });
  }

  final _$getProductListAsyncAction =
      AsyncAction('MarketplaceStoreBase.getProductList');

  @override
  Future<void> getProductList({int? limit, int? offset}) {
    return _$getProductListAsyncAction
        .run(() => super.getProductList(limit: limit, offset: offset));
  }

  final _$getDataAsyncAction = AsyncAction('MarketplaceStoreBase.getData');

  @override
  Future<void> getData() {
    return _$getDataAsyncAction.run(() => super.getData());
  }

  @override
  String toString() {
    return '''
currentPage: ${currentPage},
viewState: ${viewState},
productList: ${productList},
hasMoreItems: ${hasMoreItems}
    ''';
  }
}
