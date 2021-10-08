import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/marketplace/components/get_adaptive_size.dart';
import 'package:ootopia_app/theme/light/colors.dart';

class PurchaseButtonWidget extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final double marginBottom;
  const PurchaseButtonWidget({required this.title, this.marginBottom = 0, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: marginBottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onPressed,
              child: Padding(
                padding:  EdgeInsets.symmetric(vertical: getAdaptiveSize(15, context)),
                child: Text(
                  title,
                  style: TextStyle(fontSize: getAdaptiveSize(16, context)),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: LightColors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
