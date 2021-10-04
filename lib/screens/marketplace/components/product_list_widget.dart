import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';

class ProductItem extends StatelessWidget {
  final ProductModel productModel;
  const ProductItem({Key? key, required this.productModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 281,
      width: 171,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image(
                  height: 36,
                  width: 36,
                  fit: BoxFit.cover,
                  image: NetworkImage(productModel.user!.photoUrl!),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productModel.user!.fullname!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${productModel.user!.addressCity!}, ${productModel.user!.addressState!}',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
