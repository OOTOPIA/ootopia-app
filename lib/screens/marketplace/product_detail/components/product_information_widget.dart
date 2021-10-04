import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/theme/light/colors.dart';

class ProductInformationWidget extends StatelessWidget {
  final String informationTitle, description, oozValue;
  const ProductInformationWidget(
      {required this.informationTitle,
      required this.description,
      required this.oozValue});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 18.5, bottom: 8),
            child: Text(
              informationTitle,
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
                  child: Text(oozValue,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: LightColors.grey)),
                )
              ],
            ),
          ),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }
}
