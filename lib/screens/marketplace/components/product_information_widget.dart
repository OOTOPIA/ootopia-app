import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/screens/marketplace/marketplace_store.dart';
import 'package:ootopia_app/theme/light/colors.dart';

class ProductInformationWidget extends StatefulWidget {
  final ProductModel productModel;
  final bool isContractible;
  final double marginTopTitle, marginLeft, marginRight, marginBottom;
  const ProductInformationWidget(
      {required this.productModel,
      this.marginTopTitle = 18.5,
      this.marginLeft = 26,
      this.marginRight = 26,
      this.marginBottom = 40,
      this.isContractible = true});

  @override
  State<ProductInformationWidget> createState() =>
      _ProductInformationWidgetState();
}

class _ProductInformationWidgetState extends State<ProductInformationWidget> {
  bool expands = false;
  final marketplaceStore = MarketplaceStore();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(left: widget.marginLeft, right: widget.marginRight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: widget.marginTopTitle,
              bottom: 12,
            ),
            child: Text(
              widget.productModel.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 8,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ooz_mini_blue.svg',
                  color: Colors.black45,
                  height: 13.16,
                  width: 25,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 7.99),
                  child: Text(
                      marketplaceStore.currencyFormatter
                          .format(widget.productModel.price),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: LightColors.grey)),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.isContractible)
                setState(() {
                  expands = !expands;
                });
            },
            child: Text(
              widget.productModel.description,
              maxLines: widget.isContractible
                  ? expands
                      ? 1000
                      : 3
                  : 1000,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          SizedBox(
            height: widget.marginBottom,
          )
        ],
      ),
    );
  }
}
