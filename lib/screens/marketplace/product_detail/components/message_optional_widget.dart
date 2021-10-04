import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/get_adaptive_size.dart';
import 'package:ootopia_app/theme/light/colors.dart';

class MessageOptionalWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getAdaptiveSize(100, context),
      child: TextField(
        expands: true,
        maxLines: null,
        minLines: null,
        textAlignVertical: TextAlignVertical.top,
        style: TextStyle(fontSize: getAdaptiveSize(14, context)),
        decoration: InputDecoration(
          hintText: "Message - optional",
          hintStyle: TextStyle(
            fontSize: getAdaptiveSize(14, context),
            color: LightColors.grey,
            fontWeight: FontWeight.w500
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0.25, color: LightColors.grey)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0.25, color: LightColors.grey)),
        ),
      ),
    );
  }
}
