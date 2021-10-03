import 'package:flutter/material.dart';

List<Widget> productList(List<dynamic> list) => list
    .map(
      (e) => Container(
        alignment: Alignment.center,
        child: Text(''),
        height: 200,
        width: 200,
        decoration: BoxDecoration(
            color: Colors.amber, borderRadius: BorderRadius.circular(15)),
      ),
    )
    .toList();
