import 'package:flutter/material.dart';

class BackgroundButterflyTop extends StatelessWidget {
  final double? positioned;

  const BackgroundButterflyTop({ this.positioned});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: positioned ?? 0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            'assets/images/butterfly_top.png',
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,

          ),
        ));
  }
}

