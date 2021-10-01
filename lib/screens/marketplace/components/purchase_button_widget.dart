import 'package:flutter/material.dart';
import 'package:ootopia_app/theme/light/colors.dart';

class PurchaseButtonWidget extends StatelessWidget {
  final String title;
  final Function() onPressed;
  const PurchaseButtonWidget({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16),
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
