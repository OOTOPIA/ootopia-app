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
  late MarketplaceStore marketplaceStore;
  @override
  void initState() {
    marketplaceStore = MarketplaceStore();
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

  final list = <ProductModel>[
    ProductModel(
      id: '123',
      photoUrl:
          'https://images.pexels.com/photos/6469283/pexels-photo-6469283.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
      price: '110,0',
      title: 'Plant a tree and help to reforest the Atlantic Atlantic',
      user: User(
        fullname: 'IB Florestas',
        addressCity: 'Sao Paulo',
        addressState: 'Sao Paulo',
        photoUrl: 'https://reqres.in/img/faces/2-image.jpg',
      ),
    ),
    ProductModel(
      id: '123',
      photoUrl:
          'https://images.pexels.com/photos/6469283/pexels-photo-6469283.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
      price: '110,0',
      title: 'Daily Sustainable Tips Mini class - Dur.: 30 min',
      user: User(
        fullname: 'Luize Sehn',
        addressCity: 'Rio de Janeiro',
        addressState: 'Rio de Janeiro',
        photoUrl: 'https://reqres.in/img/faces/2-image.jpg',
      ),
    ),
  ];

  _goToWalletPage() => Navigator.pushNamed(
        context,
        PageRoute.Page.profile.route,
      );

  List<Widget> productList(List<dynamic> list) =>
      list.map((product) => ProductItem(productModel: product)).toList();
}
