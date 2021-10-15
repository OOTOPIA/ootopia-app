import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/shared/image_handler_mixin.dart';
import 'package:ootopia_app/screens/marketplace/marketplace_store.dart';
import 'package:ootopia_app/screens/marketplace/product_detail_screen.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class ProductItem extends StatelessWidget with ImageHandler {
  final ProductModel productModel;
  ProductItem({Key? key, required this.productModel}) : super(key: key);
  final pageController = SmartPageController.getInstance();

  Future<Size> getSize() async {
    return getImageSize(productModel.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final marketplaceStore = Provider.of<MarketplaceStore>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
      child: InkWell(
        onTap: () => pageController
            .insertPage(ProductDetailScreen(productModel: productModel)),
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            width: widthScreen >= 760
                ? (constraints.maxWidth / 4) - 24
                : (constraints.maxWidth / 2) - 24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ClipOval(
                        child: Image(
                          height: 36,
                          fit: BoxFit.fitHeight,
                          image: NetworkImage(productModel.userPhotoUrl),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productModel.userName,
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            '${productModel.location}',
                            style: GoogleFonts.roboto(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7.6),
                FutureBuilder<Size>(
                    future: getSize(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: widthScreen >= 760
                              ? (constraints.maxWidth / 4) - 24
                              : (constraints.maxWidth / 2) - 24,
                          height: widthScreen >= 760
                              ? (constraints.maxWidth / 4) - 24
                              : (constraints.maxWidth / 2) - 24,
                          decoration: BoxDecoration(
                            color: LightColors.grey.withOpacity(.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      }
                      return Container(
                        decoration: BoxDecoration(
                          border: isWidthGreaterThanHeight(snapshot.data!)
                              ? null
                              : Border.all(
                                  width: 1,
                                  color: LightColors.grey,
                                ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image(
                            width: widthScreen >= 760
                                ? (constraints.maxWidth / 4) - 24
                                : (constraints.maxWidth / 2) - 24,
                            height: widthScreen >= 760
                                ? (constraints.maxWidth / 4) - 24
                                : (constraints.maxWidth / 2) - 24,
                            fit: isWidthGreaterThanHeight(snapshot.data!)
                                ? BoxFit.cover
                                : BoxFit.fitHeight,
                            image: NetworkImage(productModel.imageUrl),
                          ),
                        ),
                      );
                    }),
                const SizedBox(height: 8),
                Text(
                  productModel.title,
                  style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ooz_mini_blue.svg',
                      height: 10.53,
                      width: 20,
                      color: LightColors.grey,
                    ),
                    SizedBox(width: 7),
                    Text(
                      marketplaceStore.currencyFormatter
                          .format(productModel.price),
                      style: GoogleFonts.roboto(
                        color: LightColors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
