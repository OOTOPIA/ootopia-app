import 'package:flutter/material.dart';

class BackgroundButterflyBottom extends StatelessWidget {
  final double? positioned;

  const BackgroundButterflyBottom({ this.positioned});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: positioned ?? 0,
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

