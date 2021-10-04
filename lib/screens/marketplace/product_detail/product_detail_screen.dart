import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/horizontal_expanded_image_widget.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/product_information_widget.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/profile_name_location_widget.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/purchase_button_widget.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/confirm_purchase_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductModel productModel = ProductModel(
      title: "Plant a tree and help reforest the Atlantic Forest",
      description:
          "The Tree Plant Program is an action of the IBF, aimed at restoring native forest in degraded areas, within the limits of the Atlantic Forest and Cerrado biome. The program consists of the registration of rural landowners who have areas to be restored on their properties or areas of riparian forest that must be redone.",
      imageUrl:
          "https://catracalivre.com.br/wp-content/thumbnails/gZGL4shUpQl_A8PQeMbJZTzOdDU=/wp-content/uploads/2019/09/plantas-negatividade-casa-910x590.jpg",
      oozValue: 12.00);
  final User user = User(
      addressCity: "São Paulo, São Paulo",
      photoUrl:
          "https://static.rfstat.com/renderforest/images/v2/landing-pics/logo_landing/Leaf/leaf_logo_5.jpg",
      fullname: "IBFlorestas");

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
                    profileImageUrl: user.photoUrl!,
                    profileName: user.fullname!,
                    location: user.addressCity!),
              ),
              HorizontalExpandedImageWidget(urlImage: productModel.imageUrl),
              ProductInformationWidget(
                productModel: productModel,
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(horizontal: 26),
        child: PurchaseButtonWidget(
          title: "Purchase Now",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (conetxt) => ConfirmPurchaseScreen(
                  user: user,
                  productModel: productModel,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


