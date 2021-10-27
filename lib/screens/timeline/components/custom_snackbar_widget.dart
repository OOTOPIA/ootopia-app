import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSnackbars {
  CustomSnackbars? _instance;
  late BuildContext _context;

  TextStyle _textStyle = TextStyle(color: Colors.white);

  CustomSnackbars(
    BuildContext context,
  ) {
    this._context = context;
  }

  CustomSnackbars setTextStyle(TextStyle textStyle) {
    this._textStyle = textStyle;
    return this;
  }

  SnackBar defaultSnackbar(
      {required String text,
      SnackBarAction? action,
      required Color iconColor,
      required Color backgroundColor,
      required Color textColor,
      required IconData suffixIcon}) {
    return SnackBar(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            12,
          ),
        ),
      ),
      elevation: 6,
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              suffixIcon,
              color: iconColor,
              size: 28,
            ),
          ),
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.roboto(
                  color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      action: action,
    );
  }

  SnackBar error({required String text, SnackBarAction? action}) {
    return SnackBar(
      backgroundColor: Colors.red.shade600,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            12,
          ),
        ),
      ),
      elevation: 6,
      content: Text(
        text,
        style: this._textStyle,
      ),
      behavior: SnackBarBehavior.floating,
      action: action,
    );
  }

  SnackBar whiteRoudedBackground(String text, [SnackBarAction? action]) {
    return SnackBar(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            12,
          ),
        ),
      ),
      elevation: 6,
      content: Text(
        text,
        style: this._textStyle,
      ),
      behavior: SnackBarBehavior.floating,
      action: action,
    );
  }
}
