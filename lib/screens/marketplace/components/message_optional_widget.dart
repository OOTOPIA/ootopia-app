import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessageOptionalWidget extends StatelessWidget {
  TextEditingController messageController = TextEditingController();
  final Function() onTap;
  MessageOptionalWidget({required this.messageController, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 147,
      child: TextField(
        controller: messageController,
        expands: true,
        maxLines: null,
        minLines: null,
        onTap: onTap,
        textCapitalization: TextCapitalization.sentences,
        textAlignVertical: TextAlignVertical.top,
        style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.normal),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16),
          hintText: AppLocalizations.of(context)!.messageOptional,
          hintStyle: GoogleFonts.roboto(
              fontSize: 14,
              color: Color(0xff000000).withOpacity(0.5),
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
