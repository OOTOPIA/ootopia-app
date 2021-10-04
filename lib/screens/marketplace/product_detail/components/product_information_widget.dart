import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/theme/light/colors.dart';

class ProductInformationWidget extends StatefulWidget {
  final String informationTitle, description, oozValue;
  final double marginTopTitle, horizontalMargin, marginBottom;
  const ProductInformationWidget(
      {required this.informationTitle,
      required this.description,
      required this.oozValue,
      this.marginTopTitle = 18.5,
      this.horizontalMargin = 26,
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
      margin: EdgeInsets.symmetric(horizontal: widget.horizontalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: widget.marginTopTitle, bottom: 8),
            child: Text(
              widget.informationTitle,
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
                  child: Text(widget.oozValue,
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
              widget.description,
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
