import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/horizontal_expanded_image_widget.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/product_information_widget.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/profile_name_location_widget.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/purchase_button_widget.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/transfer_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class ProductDetailScreen extends StatefulWidget {
  final SmartPageController controller;
  final ProductModel productModel;
  ProductDetailScreen({required this.productModel, required this.controller});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 26),
                child: ProfileNameLocationWidget(
                    profileImageUrl: widget.productModel.userPhotoUrl ?? "",
                    profileName: widget.productModel.userName,
                    location: widget.productModel.userLocation ?? ""),
              ),
              HorizontalExpandedImageWidget(
                  urlImage: widget.productModel.photoUrl),
              ProductInformationWidget(
                productModel: widget.productModel,
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(horizontal: 26),
        child: PurchaseButtonWidget(
          title: AppLocalizations.of(context)!.purchaseNow,
          onPressed: () {
            widget.controller.insertPage(TransferScreen(
              productModel: widget.productModel,
            ));
          },
        ),
      ),
    );
  }
}
