import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: 175.48,
            maxWidth: imageSize(screenWidth),),
          child: Image.asset(
            locale.languageCode == 'pt'
                ? 'assets/icons/new_logo_pt.png'
                : 'assets/icons/new_logo_en.png',
          ),
        ),
      ],
    );
  }

  double imageSize(screenWidth) {
    if (screenWidth <= 320) {
      return 250;
    } else if (screenWidth <= 375) {
      return 290;
    } else {
      return screenWidth - 65;
    }
  }

}
