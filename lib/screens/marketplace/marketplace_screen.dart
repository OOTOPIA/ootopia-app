import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/components/try_again.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/screens/marketplace/components/components.dart';
import 'package:ootopia_app/screens/marketplace/marketplace_store.dart';
import 'package:ootopia_app/screens/profile_screen/components/wallet_bar_widget.dart';
import 'package:ootopia_app/screens/wallet/wallet_screen.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class MarketplaceScreen extends StatefulWidget {
  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final marketplaceStore = MarketplaceStore();
  late WalletStore walletStore;
  late SmartPageController pageController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    marketplaceStore.getProductList(
        limit: marketplaceStore.itemsPerPageCount, offset: 0);
    pageController = SmartPageController.getInstance();
    _scrollController.addListener(
      () => marketplaceStore.updateOnScroll(_scrollController),
    );
    Future.delayed(Duration.zero).then((value) {
      walletStore.getWallet();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    walletStore = Provider.of<WalletStore>(context);
    return RefreshIndicator(
      onRefresh: () async {
        await walletStore.getWallet();
        await marketplaceStore.refreshData();
      },
      child: Scaffold(
        body: Observer(
          builder: (context) {
            if (marketplaceStore.viewState == ViewState.error) {
              return TryAgain(
                marketplaceStore.refreshData,
              );
            }
            return LoadingOverlay(
              isLoading: marketplaceStore.viewState == ViewState.loading,
              child: Provider(
                create: (_) => marketplaceStore,
                child: Column(
                  children: [
                    WalletBarWidget(
                        totalBalance: walletStore.wallet != null
                            ? '${marketplaceStore.currencyFormatter.format(walletStore.wallet!.totalBalance)}'
                            : '0,00',
                        onTap: () => pageController.insertPage(WalletPage())),
                    MarketplaceBarWidget(),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: 50,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                direction: Axis.horizontal,
                                children: [
                                  ...productList(marketplaceStore.productList),
                                  Visibility(
                                    visible: marketplaceStore.viewState !=
                                            ViewState.loading &&
                                        marketplaceStore.viewState !=
                                            ViewState.refresh,
                                    child: CreateOfferButtonWidget(onTap: () {
                                      Navigator.of(context).pushNamed(PageRoute
                                          .Page.aboutEthicalMarketPlace.route);
                                    }),
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
