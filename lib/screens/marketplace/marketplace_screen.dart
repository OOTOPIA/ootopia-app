import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:ootopia_app/screens/marketplace/components/components.dart';
import 'package:ootopia_app/screens/marketplace/marketplace_store.dart';
import 'package:ootopia_app/screens/profile_screen/components/wallet_bar_widget.dart';
import 'package:ootopia_app/screens/wallet/wallet_screen.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class MarketplaceScreen extends StatefulWidget {
  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final marketplaceStore = MarketplaceStore();
  late SmartPageController pageController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    marketplaceStore.getProductList(
        limit: marketplaceStore.itemsPerPageCount, offset: 0);
    pageController = SmartPageController.getInstance();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          marketplaceStore.getData();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: () async {
        marketplaceStore.productList.clear();
        marketplaceStore.currentPage = 1;
        marketplaceStore.getData();
      },
      child: Scaffold(
        body: Observer(
          builder: (context) {
            return LoadingOverlay(
              isLoading: marketplaceStore.viewState == ViewState.loading,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    WalletBarWidget(
                        onTap: () => pageController.insertPage(WalletPage())),
                    MarketplaceBarWidget(),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left:
                                GlobalConstants.of(context).intermediateSpacing,
                            top: 8.0,
                            bottom: 50,
                          ),
                          child: Column(
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: widthScreen > 720 ? 10 : 0,
                                direction: Axis.horizontal,
                                runSpacing: 24,
                                children: [
                                  ...productList(marketplaceStore.productList),
                                  Visibility(
                                    visible: marketplaceStore.viewState !=
                                        ViewState.loading,
                                    child:
                                        CreateOfferButtonWidget(onTap: () {}),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: marketplaceStore.viewState ==
                                    ViewState.loadingNewData,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> productList(List<dynamic> list) =>
      list.map((product) => ProductItem(productModel: product)).toList();
}
