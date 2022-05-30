import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/data/repositories/marketplace_repository.dart';
import 'package:ootopia_app/screens/marketplace/components/message_optional_widget.dart';
import 'package:ootopia_app/screens/marketplace/components/product_information_widget.dart';
import 'package:ootopia_app/screens/marketplace/components/profile_name_location_widget.dart';
import 'package:ootopia_app/screens/marketplace/components/purchase_button_widget.dart';
import 'package:ootopia_app/screens/marketplace/components/rounded_thumbnail_image_widget.dart';
import 'package:ootopia_app/screens/marketplace/transfer_store.dart';
import 'package:ootopia_app/screens/marketplace/transfer_success_screen.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:provider/provider.dart';

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
  late WalletStore walletStore;
  bool hasFocus = false;

  @override
  Widget build(BuildContext context) {
    walletStore = Provider.of<WalletStore>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          BackgroundButterflyTop(positioned: -59),
          Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom == 0,
              child: BackgroundButterflyBottom(positioned: -50)),
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 26, right: 26, bottom: 16),
                              child: Column(
                                children: <Widget>[
                                  ProfileNameLocationWidget(
                                    profileImageUrl:
                                        widget.productModel.userPhotoUrl,
                                    profileName: widget.productModel.userName,
                                    location: widget.productModel.location,
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              RoundedThumbnailImageWidget(
                                                imageUrl: widget
                                                    .productModel.imageUrl,
                                                radius: 12,
                                              ),
                                              Container(
                                                width:
                                                    MediaQuery.of(context)
                                                                .size
                                                                .width <
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
                                                  productModel:
                                                      widget.productModel,
                                                  marginTopTitle: 0,
                                                  marginBottom: 32,
                                                  marginLeft: 16,
                                                  marginRight: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          MessageOptionalWidget(
                                            messageController: messageOptional,
                                            onTap: () {
                                              setState(() {
                                                hasFocus = true;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Color(0xff707070).withOpacity(0.2),
                              height: 1,
                              thickness: 1,
                            ),
                          ],
                        ),
                      ),
                      Observer(builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(children: [
                            Expanded(
                              child: PurchaseButtonWidget(
                                  content: transferStore.isLoading
                                      ? loadingWidget()
                                      : Text(
                                          AppLocalizations.of(context)!.confirm,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                  marginBottom: 24,
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    makePurchase();
                                  }),
                            )
                          ]),
                        );
                      }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget loadingWidget() => Container(
        height: 20,
        width: 20,
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.transparent,
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );

  void makePurchase() async {
    try {
      final response = await transferStore.makePurchase(
          productId: widget.productModel.id,
          optionalMessage: messageOptional.text);
      if (response) {
        await walletStore.getWallet();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TransferSuccessScreen()));
      }
    } catch (e) {
      transferStore.showSnackbarMessage(
          context: context, message: e.toString());
    }
  }
}
