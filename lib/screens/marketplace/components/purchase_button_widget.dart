import 'package:flutter/material.dart';
import 'package:ootopia_app/theme/light/colors.dart';

class PurchaseButtonWidget extends StatelessWidget {
  final Widget content;
  final Function() onPressed;
  final double marginBottom;
  const PurchaseButtonWidget({required this.content, this.marginBottom = 0, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: marginBottom),
      child: Container(
        width: 366,
        height: 53,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 15),
            child: content
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: LightColors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45.0),
            ),
          ),
        ),
      ),
    );
  }
}
