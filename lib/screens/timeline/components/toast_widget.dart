import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/shared/global-constants.dart';

class ToastWidget extends StatelessWidget {
  final String text;
  final IconData suffixIcon;
  final Color backgroundColor, textColor, iconColor;
  const ToastWidget(
      {required this.text,
      required this.suffixIcon,
      this.backgroundColor = const Color(0xff03DAC5),
      this.iconColor = Colors.white,
      this.textColor = Colors.white});
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 6)).then((_) => Navigator.pop(context));
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 24, bottom: 24, right: 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    GlobalConstants.of(context).spacingNormal,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(suffixIcon, color: iconColor, size: 28,),
                      ),
                      Flexible(
                        child: Text(
                          text,
                          style: GoogleFonts.roboto(color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
