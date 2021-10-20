import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/screens/marketplace/components/horizontal_expanded_image_widget.dart';
import 'package:ootopia_app/screens/marketplace/components/product_information_widget.dart';
import 'package:ootopia_app/screens/marketplace/components/profile_name_location_widget.dart';
import 'package:ootopia_app/screens/marketplace/components/purchase_button_widget.dart';
import 'package:ootopia_app/screens/marketplace/transfer_screen.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel productModel;
  ProductDetailScreen({required this.productModel});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final pageController = SmartPageController.getInstance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          right: 16,
                          left: 26,
                        ),
                        child: ProfileNameLocationWidget(
                          profileImageUrl: widget.productModel.userPhotoUrl,
                          profileName: widget.productModel.userName,
                          location: widget.productModel.location,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            HorizontalExpandedImageWidget(
                                urlImage: widget.productModel.imageUrl),
                            ProductInformationWidget(
                              productModel: widget.productModel,
                              isContractible: false,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              Expanded(
                                child: PurchaseButtonWidget(
                                  content: Text(
                                    AppLocalizations.of(context)!
                                        .purchaseNow,
                                    style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  marginBottom: 24,
                                  onPressed: () {
                                    pageController
                                        .insertPage(TransferScreen(
                                      productModel: widget.productModel,
                                    ));
                                  },
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
