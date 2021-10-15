import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class TransferSuccessScreen extends StatefulWidget {
  final bool goToMarketPlacePage;
  TransferSuccessScreen({this.goToMarketPlacePage = true});

  @override
  State<TransferSuccessScreen> createState() => _TransferSuccessScreenState();
}

class _TransferSuccessScreenState extends State<TransferSuccessScreen> {
  final pageController = SmartPageController.getInstance();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.setStatusBar(false);
    });
  }

  void setStatusBar(bool getOutScreen) {
    if (getOutScreen) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle());
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
            margin: EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 50, bottom: 32),
                      child: Text(
                        AppLocalizations.of(context)!.ethicalMarketplace,
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .ethicalMarketplaceDescription,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                Image.asset(
                  "assets/images/wallet.png",
                  scale: 2,
                ),
                Text(
                  AppLocalizations.of(context)!.thanksForYourOrder,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
                Text(
                  AppLocalizations.of(context)!.messageVendorContact,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 24),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0),
                        )),
                    onPressed: () {
                      if (widget.goToMarketPlacePage)
                        pageController.resetNavigation(
                            redirectToBottomOptionIndex: 3);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      child: Text(
                        AppLocalizations.of(context)!.close,
                        style: TextStyle(
                            color: LightColors.silverText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  "Picture by Clem Onojeghuo",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
