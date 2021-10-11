import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/screens/marketplace/components/get_adaptive_size.dart';
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
      margin: EdgeInsets.only(
          left: getAdaptiveSize(widget.marginLeft, context),
          right: getAdaptiveSize(widget.marginRight, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: getAdaptiveSize(widget.marginTopTitle, context),
              bottom: getAdaptiveSize(12, context),
            ),
            child: Text(
              widget.productModel.title,
              style: TextStyle(
                  fontSize: getAdaptiveSize(20, context),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: getAdaptiveSize(8, context),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ooz_mini_blue.svg',
                  color: Colors.black45,
                  height: getAdaptiveSize(13.27, context),
                  width: getAdaptiveSize(25.21, context),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: getAdaptiveSize(7.99, context)),
                  child: Text( marketplaceStore.currencyFormatter
                            .format(widget.productModel.price),
                      style: TextStyle(
                          fontSize: getAdaptiveSize(14, context),
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
                      ? 100
                      : 3
                  : 100,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: getAdaptiveSize(14, context),
                  color: Colors.black87),
            ),
          ),
          SizedBox(
            height: getAdaptiveSize(widget.marginBottom, context),
          )
        ],
      ),
    );
  }
}
