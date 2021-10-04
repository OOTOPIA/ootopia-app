import 'package:flutter/material.dart';
import 'package:ootopia_app/theme/light/colors.dart';

class MessageOptionalWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: TextField(
        expands: true,
        maxLines: null,
        minLines: null,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          hintText: "Message - optional",
          hintStyle: TextStyle(
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
