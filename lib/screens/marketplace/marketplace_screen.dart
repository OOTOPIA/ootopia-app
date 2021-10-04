import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/screens/marketplace/components/marketplace_bar_widget.dart';
import 'package:ootopia_app/screens/marketplace/components/product_list_widget.dart';

import 'package:ootopia_app/screens/profile_screen/components/wallet_bar_widget.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class MarketplaceScreen extends StatefulWidget {
  MarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    runSpacing: 24,
                    spacing: 24,
                    children: [
                      ...productList(list),
                      Container(
                        alignment: Alignment.center,
                        child: Text(''),
                        height: 171,
                        width: 171,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15)),
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
  }

  final list = <ProductModel>[
    ProductModel(
        id: '123',
        photoUrl: 'https://reqres.in/img/faces/2-image.jpg',
        price: '110.0',
        title: 'Plant a tree and help to reforest the Atlantic',
        user: User(
          fullname: 'IB Florestas',
          addressCity: 'Sao Paulo',
          addressState: 'Sao Paulo',
          photoUrl: 'https://reqres.in/img/faces/2-image.jpg',
        )),
  ];

  _goToWalletPage() => Navigator.pushNamed(
        context,
        PageRoute.Page.profile.route,
      );

  List<Widget> productList(List<dynamic> list) =>
      list.map((product) => ProductItem(productModel: product)).toList();
}
