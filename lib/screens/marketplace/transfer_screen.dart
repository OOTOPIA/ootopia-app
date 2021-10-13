import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/data/repositories/marketplace_repository.dart';
import 'package:ootopia_app/screens/marketplace/components/get_adaptive_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/screens/marketplace/components/message_optional_widget.dart';
import 'package:ootopia_app/screens/marketplace/components/product_information_widget.dart';
import 'package:ootopia_app/screens/marketplace/components/profile_name_location_widget.dart';
import 'package:ootopia_app/screens/marketplace/components/purchase_button_widget.dart';
import 'package:ootopia_app/screens/marketplace/components/rounded_thumbnail_image_widget.dart';
import 'package:ootopia_app/screens/marketplace/transfer_store.dart';
import 'package:ootopia_app/screens/marketplace/transfer_success_screen.dart';

class TransferScreen extends StatefulWidget {
  final ProductModel productModel;

  const TransferScreen({Key? key, required this.productModel})
      : super(key: key);

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final messageOptional = TextEditingController();
  final marketplaceRepositoryImpl = MarketplaceRepositoryImpl();
  final transferStore = TransferStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
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
                          profileImageUrl: widget.productModel.userPhotoUrl,
                          profileName: widget.productModel.userName,
                          location: widget.productModel.location,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      RoundedThumbnailImageWidget(
                                        imageUrl: widget.productModel.imageUrl,
                                        radius: 12,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width <
                                                    400
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.58
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.65,
                                        child: ProductInformationWidget(
                                          productModel: widget.productModel,
                                          marginTopTitle: 0,
                                          marginBottom:
                                              getAdaptiveSize(32, context),
                                          marginLeft:
                                              getAdaptiveSize(16, context),
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
                              Observer(builder: (context) {
                                return PurchaseButtonWidget(
                                    content: transferStore.isLoading
                                        ? loadingWidget()
                                        : Text(
                                            AppLocalizations.of(context)!
                                                .confirm,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                    marginBottom: getAdaptiveSize(23, context),
                                    onPressed: () => makePurchase());
                              }),
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
        ),
      ),
    );
  }

  Widget loadingWidget() => Container(
        height: getAdaptiveSize(20, context),
        width: getAdaptiveSize(20, context),
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.transparent,
            strokeWidth: getAdaptiveSize(2, context),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );

  void makePurchase() async {
    try {
      final response = await transferStore.makePurchase(
          productId: widget.productModel.id,
          optionalMessage: messageOptional.text);
      if (response)
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TransferSuccessScreen()));
    } catch (e) {
      transferStore.showSnackbarMessage(
          context: context, message: e.toString());
    }
  }
}
