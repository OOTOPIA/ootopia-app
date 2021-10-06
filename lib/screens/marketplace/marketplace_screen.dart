import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/home/home_screen.dart';

import 'package:ootopia_app/screens/marketplace/components/components.dart';
import 'package:ootopia_app/screens/marketplace/marketplace_store.dart';
import 'package:ootopia_app/screens/profile_screen/components/wallet_bar_widget.dart';
import 'package:ootopia_app/screens/wallet/wallet_screen.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:smart_page_navigation/smart_page_navigation.dart';

class MarketplaceScreen extends StatefulWidget {
  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final marketplaceStore = MarketplaceStore();
  late SmartPageController pageController;
  @override
  void initState() {
    marketplaceStore.getProductList(
        limit: marketplaceStore.itemsPerPageCount, offset: 0);
    pageController = SmartPageController.getInstance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            direction: Axis.horizontal,
                            runSpacing: 24,
                            spacing: 24,
                            children: [
                              ...productList(marketplaceStore.productList),
                              Visibility(
                                visible: marketplaceStore.viewState ==
                                    ViewState.done,
                                child: CreateOfferButtonWidget(onTap: () {}),
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

  _goToWalletPage() => Navigator.pushNamed(
        context,
        PageRoute.Page.profile.route,
      );

  List<Widget> productList(List<dynamic> list) =>
      list.map((product) => ProductItem(productModel: product)).toList();
}
