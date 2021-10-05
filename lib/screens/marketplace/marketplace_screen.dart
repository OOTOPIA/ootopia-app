import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/marketplace/components/components.dart';
import 'package:ootopia_app/screens/marketplace/marketplace_store.dart';
import 'package:ootopia_app/screens/profile_screen/components/wallet_bar_widget.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class MarketplaceScreen extends StatefulWidget {
  MarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final marketplaceStore = MarketplaceStore();

  @override
  void initState() {
    marketplaceStore.getProductList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (context) {
          return LoadingOverlay(
            isLoading: marketplaceStore.viewState == ViewState.loading,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  WalletBarWidget(onTap: _goToWalletPage),
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
                            CreateOfferButtonWidget(onTap: () {}),
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
    );
  }

  _goToWalletPage() => Navigator.pushNamed(
        context,
        PageRoute.Page.profile.route,
      );

  List<Widget> productList(List<dynamic> list) =>
      list.map((product) => ProductItem(productModel: product)).toList();
}
