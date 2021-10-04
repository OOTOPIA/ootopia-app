import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/get_adaptive_size.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/message_optional_widget.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/product_information_widget.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/profile_name_location_widget.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/purchase_button_widget.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/rounded_thumbnail_image_widget.dart';

class ConfirmPurchaseScreen extends StatelessWidget {
  final User user;
  final ProductModel productModel;

  const ConfirmPurchaseScreen(
      {Key? key, required this.user, required this.productModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: LayoutBuilder(
      builder: (context, constraint) {
        return Container(
          margin: EdgeInsets.only(
            right: getAdaptiveSize(16, context),
            left: getAdaptiveSize(16, context),
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    ProfileNameLocationWidget(
                      profileImageUrl: user.photoUrl!,
                      profileName: user.fullname!,
                      location: user.addressCity!,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RoundedThumbnailImageWidget(
                                    imageUrl: productModel.imageUrl,
                                    radius: 12,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width < 400
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.55
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.65,
                                    child: ProductInformationWidget(
                                      productModel: productModel,
                                      marginTopTitle: 0,
                                      marginBottom:
                                          getAdaptiveSize(24, context),
                                      marginLeft: getAdaptiveSize(16, context),
                                      marginRight: 0,
                                    ),
                                  ),
                                ],
                              ),
                              MessageOptionalWidget(),
                            ],
                          ),
                          PurchaseButtonWidget(
                              title: "Confirm",
                              marginBottom: getAdaptiveSize(10, context),
                              onPressed: () {})
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    )));
  }
}
