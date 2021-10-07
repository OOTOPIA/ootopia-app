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
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: () => debugPrint('click'),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: widthScreen >= 760
                  ? (constraints.maxWidth / 4) - 24
                  : (constraints.maxWidth / 2) - 24,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: LightColors.grey,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ClipOval(
                          child: Image(
                            height: widthScreen <= 320 ? 28 : 36,
                            fit: BoxFit.fitHeight,
                            image: NetworkImage(productModel.userPhotoUrl),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productModel.userName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: widthScreen <= 360 ? 12 : 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              '${productModel.location}',
                              style: TextStyle(
                                  fontSize: widthScreen <= 360 ? 10 : 12),
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
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: LightColors.grey,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image(
                        height: widthScreen >= 760
                            ? (constraints.maxWidth / 4) - 24
                            : (constraints.maxWidth / 2) - 24,
                        width: widthScreen >= 760
                            ? (constraints.maxWidth / 4) - 24
                            : (constraints.maxWidth / 2) - 24,
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(productModel.imageUrl),
                      ),
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
      ),
    );
  }
}
