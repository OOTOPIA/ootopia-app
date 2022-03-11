import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/components/share_link.dart';
import 'package:ootopia_app/screens/marketplace/components/horizontal_expanded_image_widget.dart';
import 'package:ootopia_app/screens/marketplace/components/product_information_widget.dart';
import 'package:ootopia_app/screens/marketplace/components/profile_name_location_widget.dart';
import 'package:ootopia_app/screens/marketplace/components/purchase_button_widget.dart';
import 'package:ootopia_app/screens/marketplace/transfer_screen.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class ProductDetailScreen extends StatefulWidget {
  final ProductModel productModel;
  ProductDetailScreen({required this.productModel});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final pageController = SmartPageController.getInstance();
  late AuthStore authStore;
  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);
    return Scaffold(
      body: Stack(
        children: [
          BackgroundButterflyTop(positioned: -59),
          BackgroundButterflyBottom(positioned: -50),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraint) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                              right: 26,
                              left: 26,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ProfileNameLocationWidget(
                                  profileImageUrl:
                                      widget.productModel.userPhotoUrl,
                                  profileName: widget.productModel.userName,
                                  location: widget.productModel.location,
                                ),
                                ShareLink(
                                  type: Type.offer,
                                  id: widget.productModel.id,
                                )
                              ],
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
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: [
                                Expanded(
                                  child: PurchaseButtonWidget(
                                    content: Text(
                                      AppLocalizations.of(context)!.purchaseNow,
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    marginBottom: 24,
                                    onPressed: () {
                                      if (authStore.currentUser == null) {
                                        Navigator.of(context).pushNamed(
                                          PageRoute.Page.loginScreen.route,
                                          arguments: {
                                            "returnToPageWithArgs": {
                                              "currentPageName": "marketplace",
                                              "arguments": null
                                            }
                                          },
                                        );
                                      } else {
                                        pageController
                                            .insertPage(TransferScreen(
                                          productModel: widget.productModel,
                                        ));
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
