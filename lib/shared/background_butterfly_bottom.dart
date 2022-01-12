import 'package:flutter/material.dart';

class BackgroundButterflyBottom extends StatelessWidget {
  const BackgroundButterflyBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            'assets/images/butterfly_bottom.png',
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,

          ),
        ));
  }
}

