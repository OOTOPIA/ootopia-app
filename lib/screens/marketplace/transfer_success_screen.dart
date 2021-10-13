import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/marketplace/components/get_adaptive_size.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class TransferSuccessScreen extends StatelessWidget {
  final pageController = SmartPageController.getInstance();
  final bool goToMarketPlacePage;
  TransferSuccessScreen({this.goToMarketPlacePage = true});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Image.asset(
                "assets/images/success_order.png",
                fit: BoxFit.fill,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.symmetric(
                  horizontal: getAdaptiveSize(26, context)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.ethicalMarketplace,
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  Text(
                    AppLocalizations.of(context)!.ethicalMarketplaceDescription,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  CircleAvatar(
                      backgroundColor: LightColors.blue,
                      radius: getAdaptiveSize(80, context),
                      child: Image.asset(
                        "assets/images/wallet.png",
                        scale: MediaQuery.of(context).size.width > 720 ? 2 : 4,
                      )),
                  Text(
                    AppLocalizations.of(context)!.thanksForYourOrder,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28),
                  ),
                  Text(
                    AppLocalizations.of(context)!.messageVendorContact,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0),
                        )),
                    onPressed: () {
                      if (goToMarketPlacePage)
                        pageController.resetNavigation(
                            redirectToBottomOptionIndex: 3);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getAdaptiveSize(20, context),
                          vertical: getAdaptiveSize(18, context)),
                      child: Text(
                        AppLocalizations.of(context)!.close,
                        style: TextStyle(
                            color: LightColors.silverText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
