import 'package:flutter/material.dart';

List<Widget> productList(List<dynamic> list) =>
    list.map((e) => ProductItem()).toList();

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(''),
      height: 281,
      width: 171,
      decoration: BoxDecoration(
          color: Colors.amber, borderRadius: BorderRadius.circular(15)),
    );
  }
}
