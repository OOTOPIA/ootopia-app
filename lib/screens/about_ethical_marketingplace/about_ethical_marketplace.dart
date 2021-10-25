import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class AboutEthicalMarketPlace extends StatefulWidget {
  const AboutEthicalMarketPlace({Key? key}) : super(key: key);

  @override
  _AboutEthicalMarketPlaceState createState() =>
      _AboutEthicalMarketPlaceState();
}

class _AboutEthicalMarketPlaceState extends State<AboutEthicalMarketPlace> {
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 350), () {
      this.setStatusBar(false);
    });
    super.initState();

    trackingEvents.creteOfferMarketPlace();
  }

  @override
  void dispose() {
    super.dispose();
    this.setStatusBar(true);
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
      primary: true,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            'assets/images/image_background_ooz_current.png',
          ),
          fit: BoxFit.cover,
        )),
        child: Center(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                fillOverscroll: true,
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                height:
                                    GlobalConstants.of(context).spacingLarge,
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .ethicalMarketplace
                                    .toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      spreadRadius: 0,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 5), // changes position of shadow
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: GlobalConstants.of(context)
                                    .intermediateSpacing,
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .ethicalMarketplaceDescription,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      spreadRadius: 0,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 5), // changes position of shadow
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 26),
                              Image.asset(
                                "assets/images/wallet.png",
                                height: 156,
                                width: 156,
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .aboutYourOfferHere,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      spreadRadius: 0,
                                      blurRadius: 5,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .nextAboutCreateOffer,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      spreadRadius: 0,
                                      blurRadius: 5,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                  height: GlobalConstants.of(context)
                                      .spacingMedium),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, right: 16),
                            child: RotatedBox(
                              quarterTurns: -1,
                              child: RichText(
                                text: TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .pictureByClemOnojeghuo,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          bottom: 24, left: 24, right: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all<Size>(
                                    Size(88, 53)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide.none),
                                ),
                                shadowColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(15)),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                AppLocalizations.of(context)!.close,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          ElevatedButton(
                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all<Size>(
                                    Size(212, 53)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide.none),
                                ),
                                shadowColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xff003694)),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(15)),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  PageRoute.Page.chatWithUsersScreen.route,
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.giveSuggestion,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
