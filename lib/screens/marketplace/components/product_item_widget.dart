import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/theme/light/colors.dart';

class ProductItem extends StatelessWidget {
  final ProductModel productModel;
  const ProductItem({Key? key, required this.productModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () => debugPrint('click'),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            alignment: Alignment.center,
            width: widthScreen >= 760 ? 171 : constraints.maxWidth / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Image(
                        height: 36,
                        fit: BoxFit.fitHeight,
                        image: NetworkImage(productModel.userPhotoUrl),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productModel.userName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            '${productModel.location}',
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7.6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image(
                    height:
                        widthScreen >= 760 ? 171 : constraints.maxWidth / 2.2,
                    width:
                        widthScreen >= 760 ? 171 : constraints.maxWidth / 2.2,
                    fit: BoxFit.cover,
                    image: NetworkImage(productModel.imageUrl),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  productModel.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ooz_mini_blue.svg',
                      height: 10,
                      color: LightColors.grey,
                    ),
                    SizedBox(width: 7),
                    Text(
                      '${productModel.price}',
                      style: TextStyle(color: LightColors.grey),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
