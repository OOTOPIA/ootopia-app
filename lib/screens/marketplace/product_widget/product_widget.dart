import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/marketplace/components/create_offer_button_widget.dart';
import 'package:ootopia_app/screens/marketplace/components/product_item_widget.dart';
import 'package:ootopia_app/screens/marketplace/marketplace_store.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class ProductWidget extends StatelessWidget {
  final bool isLastItem;
  final double headerSize;
  final List list;
  final int itemsPerLine;
  final int index;
  final double size;
  final MarketplaceStore marketplaceStore;

  const ProductWidget({Key? key,
    required this.isLastItem,
    required this.headerSize,
    required this.list,
    required this.itemsPerLine,
    required this.index,
    required this.size,
    required this.marketplaceStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLastItem ? headerSize : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            children: [
              for (int i=0; i < getAmountOfItems(isLastItem, list.length, itemsPerLine); i++)...[
                ProductItem(productModel: list[index * itemsPerLine + i]),
              ],
              if(isLastItem)...[
                CreateOfferButtonWidget(
                    topMargin: list.length % itemsPerLine != 0,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          PageRoute.Page.aboutEthicalMarketPlace.route);
                    }),
                SizedBox(
                  width: size,
                )
              ]
            ],
          ),
          if(isLastItem && marketplaceStore.loadingMoreItems())...[
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: CircularProgressIndicator(),
            )
          ]
        ],
      ),
    );
  }

  int getAmountOfItems(bool lastNine, int length, itemsPerLine) {
    return (lastNine ? length % itemsPerLine : itemsPerLine);
  }
}
