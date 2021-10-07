import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/data/repositories/marketplace_repository.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/get_adaptive_size.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/message_optional_widget.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/product_information_widget.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/profile_name_location_widget.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/purchase_button_widget.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/components/rounded_thumbnail_image_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/screens/marketplace/product_detail/transfer_success_screen.dart';

class TransferScreen extends StatefulWidget {
  final ProductModel productModel;

  const TransferScreen({Key? key, required this.productModel})
      : super(key: key);

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  TextEditingController messageOptional = TextEditingController();
  MarketplaceRepositoryImpl marketplaceRepositoryImpl =
      MarketplaceRepositoryImpl();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: LayoutBuilder(
      builder: (context, constraint) {
        return Container(
          margin: EdgeInsets.only(
            right: getAdaptiveSize(26, context),
            left: getAdaptiveSize(26, context),
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    ProfileNameLocationWidget(
                      profileImageUrl: widget.productModel.userPhotoUrl ?? "",
                      profileName: widget.productModel.userName,
                      location: widget.productModel.userLocation ?? "",
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RoundedThumbnailImageWidget(
                                    imageUrl: widget.productModel.photoUrl,
                                    radius: 12,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width < 400 ? MediaQuery.of(context).size.width *
                                        0.58 : MediaQuery.of(context).size.width *
                                        0.65,
                                    child: ProductInformationWidget(
                                      productModel: widget.productModel,
                                      marginTopTitle: 0,
                                      marginBottom:
                                          getAdaptiveSize(24, context),
                                      marginLeft: getAdaptiveSize(16, context),
                                      marginRight: 0,
                                    ),
                                  ),
                                ],
                              ),
                              MessageOptionalWidget(
                                messageController: messageOptional,
                              ),
                            ],
                          ),
                          PurchaseButtonWidget(
                            title: AppLocalizations.of(context)!.confirm,
                            marginBottom: getAdaptiveSize(10, context),
                            onPressed: makePurchase,
                          )
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

  Future<void> makePurchase() async {
    final response = await marketplaceRepositoryImpl.makePurchase(
        productId: "40accdaa-191a-4369-aa3a-54f50e2869de",
        optionalMessage: messageOptional.text);

    if (response)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransferSuccessScreen(),
        ),
      );
    debugPrint("ERRO AO COMPRAR PRODUTO");
  }
}
