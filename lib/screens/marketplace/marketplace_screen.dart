import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/marketplace/components/marketplace_bar_widget.dart';
import 'package:ootopia_app/screens/marketplace/components/product_list_widget.dart';

import 'package:ootopia_app/screens/profile_screen/components/wallet_bar_widget.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

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
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.horizontal,
                  runSpacing: MediaQuery.of(context).size.width * 0.02,
                  spacing: MediaQuery.of(context).size.width * 0.02,
                  children: [
                    ...productList(list),
                    Container(
                      alignment: Alignment.center,
                      child: Text(''),
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final list = [1, 2, 3, 4];
  _goToWalletPage() => Navigator.pushNamed(
        context,
        PageRoute.Page.profile.route,
      );
}
