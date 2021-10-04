import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/theme/light/colors.dart';

class ProductInformationWidget extends StatefulWidget {
  final ProductModel productModel;
  final double marginTopTitle, marginLeft, marginRight,  marginBottom;
  const ProductInformationWidget(
      {required this.productModel,
      this.marginTopTitle = 18.5,
      this.marginLeft = 26,
      this.marginRight = 26,
      this.marginBottom = 80});

  @override
  State<ProductInformationWidget> createState() =>
      _ProductInformationWidgetState();
}

class _ProductInformationWidgetState extends State<ProductInformationWidget> {
  bool expands = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: widget.marginLeft, right: widget.marginRight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: widget.marginTopTitle, bottom: 12),
            child: Text(
              widget.productModel.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  height: 13.27,
                  width: 25.21,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 7.99),
                  child: Text(widget.productModel.oozValue.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: LightColors.grey)),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                expands = !expands;
              });
            },
            child: Text(
              widget.productModel.description,
              maxLines: expands ? 100 : 3,
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
