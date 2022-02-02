import 'package:flutter/material.dart';

class Slogan extends StatelessWidget {
  const Slogan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: 42,
            maxWidth:imageSize(screenWidth),
          ),
          child: Image.asset(
            locale.languageCode == 'pt'
                ? 'assets/icons/slogan_pt.png'
                : 'assets/icons/slogan_en.png',
            width: imageSize(screenWidth),
          ),
        ),
      ],
    );
  }

  double imageSize (screenWidth){
    if(screenWidth <= 320){
      return 270;
    }else if(screenWidth <= 375){
      return 300;
    }else{
      return screenWidth - 65;
    }

  }
}
