import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/marketplace/components/get_adaptive_size.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessageOptionalWidget extends StatelessWidget {
  TextEditingController messageController = TextEditingController();
  MessageOptionalWidget({required this.messageController});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getAdaptiveSize(120, context),
      child: TextField(
        controller: messageController,
        expands: true,
        maxLines: null,
        minLines: null,
        textAlignVertical: TextAlignVertical.top,
        style: TextStyle(fontSize: getAdaptiveSize(14, context), fontWeight: FontWeight.normal),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(getAdaptiveSize(16, context)),
          hintText: AppLocalizations.of(context)!.messageOptional,
          hintStyle: TextStyle(
              fontSize: 14,
              color: LightColors.grey,
              fontWeight: FontWeight.w500),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0.25, color: LightColors.grey)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0.25, color: LightColors.grey)),
        ),
      ),
    );
  }
}
