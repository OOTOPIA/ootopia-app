import 'package:flutter/material.dart';

class Slogan extends StatelessWidget {
  const Slogan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    final screenWidth = MediaQuery.of(context).size.width;
    print(screenWidth);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: 42,
            maxWidth: screenWidth <= 320
                ? 270
                : screenWidth <= 375
                    ? 300
                    : double.infinity,
          ),
          child: Image.asset(
            locale.languageCode == 'pt'
                ? 'assets/icons/slogan_pt.png'
                : 'assets/icons/slogan_en.png',
          ),
        ),
      ],
    );
  }
}
