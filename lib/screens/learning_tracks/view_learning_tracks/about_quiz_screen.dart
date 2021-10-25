import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/global-constants.dart';

class AboutQuizScreen extends StatefulWidget {
  @override
  _AboutQuizScreenState createState() => _AboutQuizScreenState();
}

class _AboutQuizScreenState extends State<AboutQuizScreen> {
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 350), () {
      this.setStatusBar(false);
    });
    trackingEvents.learningTracksQuiz();
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
  void dispose() {
    super.dispose();
    this.setStatusBar(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            'assets/images/kids_words.png',
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
                    Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 26),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 50),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .regenerationGame
                                        .toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          spreadRadius: 0,
                                          blurRadius: 3,
                                          offset: Offset(0,
                                              5), // changes position of shadow
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          spreadRadius: 0,
                                          blurRadius: 3,
                                          offset: Offset(1,
                                              5), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: GlobalConstants.of(context)
                                        .intermediateSpacing,
                                  ),
                                  Center(
                                      child: CircleAvatar(
                                          backgroundColor: Color(0xff003694),
                                          radius: 78,
                                          child: Image.asset(
                                            'assets/icons/ooz_white.png',
                                            height: 119,
                                            width: 62.08,
                                            color: Colors.white,
                                          ))),
                                  SizedBox(
                                      height: GlobalConstants.of(context)
                                          .intermediateSpacing),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .quiz
                                        .toUpperCase(),
                                    style: TextStyle(
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          spreadRadius: 0,
                                          blurRadius: 3,
                                          offset: Offset(0,
                                              5), // changes position of shadow
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          spreadRadius: 0,
                                          blurRadius: 3,
                                          offset: Offset(1,
                                              5), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                      height: GlobalConstants.of(context)
                                          .spacingMedium),
                                  Text(
                                    AppLocalizations.of(context)!.nextAboutQuiz,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          spreadRadius: 0,
                                          blurRadius: 5,
                                          offset: Offset(0,
                                              5), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(
                                      height: GlobalConstants.of(context)
                                          .spacingMedium),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .plusQuizAboutOOz,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 23,
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          spreadRadius: 0,
                                          blurRadius: 5,
                                          offset: Offset(0,
                                              5), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 16, right: 16),
                                child: RotatedBox(
                                  quarterTurns: -1,
                                  child: RichText(
                                    text: TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .pictureByMikaBaumeister,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 28),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all<Size>(Size(104, 53)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: BorderSide.none),
                            ),
                            shadowColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(15)),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            AppLocalizations.of(context)!.close,
                            style: TextStyle(
                              color: Color(0xff666666),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
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
