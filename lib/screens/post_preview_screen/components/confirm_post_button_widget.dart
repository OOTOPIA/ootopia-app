import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/marketplace/components/get_adaptive_size.dart';
import 'package:ootopia_app/theme/light/colors.dart';

class ConfirmButtonWidget extends StatelessWidget {
  final Widget content;
  final Function() onPressed;
  const ConfirmButtonWidget({required this.content, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onPressed,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18), child: content),
              style: ElevatedButton.styleFrom(
                elevation: 0,
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
