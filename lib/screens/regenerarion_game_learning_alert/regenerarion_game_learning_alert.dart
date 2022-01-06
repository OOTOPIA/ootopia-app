import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/screens/learning_tracks/learning_tracks_store.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RegenerarionGameLearningAlert extends StatefulWidget {
  final Map<String, dynamic> args;


  RegenerarionGameLearningAlert(this.args);

  @override
  _RegenerarionGameLearningAlertState createState() =>
      _RegenerarionGameLearningAlertState();
}

class _RegenerarionGameLearningAlertState
    extends State<RegenerarionGameLearningAlert> {
  String? _imagePath;
  Color? _backgroundColorIcon;
  String? _icon;
  String? _title;
  String? _firstText;
  String? _secondText;
  String? _secondTextPt2;
  SharedPreferences? prefs;

  String? _imageRights;
  bool dontShowAgainRegenerationGamePega = false;

  SmartPageController controller = SmartPageController.getInstance();
  LearningTracksModel? welcomeGuideLearningTrack;
  LearningTracksStore learningTracksStore = LearningTracksStore();

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
  void initState() {
    switch (widget.args["type"]) {
      case "personal":
        _imagePath = "assets/images/personal_background.png";
        _backgroundColorIcon = Color(0xff00A5FC);
        _icon = "assets/icons/personal_icon.svg";
        _title = AppLocalizations.of(widget.args["context"])!.personalLevel;
        _firstText =
            AppLocalizations.of(widget.args["context"])!.personalLevelText1;
        _secondText =
            AppLocalizations.of(widget.args["context"])!.personalLevelText2;
        _imageRights = "Picture by Jan Huber";
        break;

      case "city":
        _imagePath = "assets/images/city_background.png";
        _backgroundColorIcon = Color(0xff0072C5);
        _icon = "assets/icons/city_icon.svg";
        _title = AppLocalizations.of(widget.args["context"])!.cityLevel;
        _firstText =
            AppLocalizations.of(widget.args["context"])!.cityLevelText1;
        _secondText =
            AppLocalizations.of(widget.args["context"])!.cityLevelText2;
        _imageRights = "Picture by Shane Rounce";

        break;

      case "global":
        _imagePath = "assets/images/planetary_background.png";
        _backgroundColorIcon = Color(0xff012588);
        _icon = "assets/icons/global_icon.svg";
        _title = AppLocalizations.of(widget.args["context"])!.planetaryLevel;
        _firstText =
            AppLocalizations.of(widget.args["context"])!.planetaryLevelText1;
        _secondText =
            AppLocalizations.of(widget.args["context"])!.planetaryLevelText2pt1;
        _secondTextPt2 =
            AppLocalizations.of(widget.args["context"])!.planetaryLevelText2pt2;
        _imageRights = "Picture by Margot Richard";

        break;
    }
    super.initState();
    Future.delayed(Duration.zero, () async {
      welcomeGuideLearningTrack = await learningTracksStore.getWelcomeGuide();
      prefs = await SharedPreferences.getInstance();
    });
    Future.delayed(Duration(milliseconds: 350), () {
      this.setStatusBar(false);
    });
  }

  isSmallPhone(double value) {
    if (MediaQuery.of(context).size.width < 380) return value * 0.7;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: (){
        return new Future(() => false);
        },
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_imagePath as String),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Positioned(
              //   top: 90,
              //   right: -36,
              //   child: Transform.rotate(
              //       angle: 3 * pi / 2,
              //       child: Container(
              //         child: Text(
              //           _imageRights as String,
              //           textAlign: TextAlign.right,
              //           style: Theme.of(context).textTheme.bodyText1!.copyWith(
              //                 fontSize: 10,
              //                 color: Colors.white,
              //               ),
              //         ),
              //       )),
              // ),
              CustomScrollView(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                                horizontal: GlobalConstants.of(context)
                                    .screenHorizontalSpace)
                            .copyWith(top: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                Text(
                                  AppLocalizations.of(context)!
                                      .regenerationGame
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          color: Colors.white,
                                          fontSize: screenWidth <= 375 ? 18 : 22,
                                          fontWeight: FontWeight.w400)
                                      .copyWith(
                                    shadows: [
                                      Shadow(
                                        blurRadius: 3.0,
                                        color: Colors.black.withOpacity(.25),
                                        offset: Offset(
                                          0,
                                          5.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: screenWidth <= 375 ? 80 : 160,
                                  height: screenWidth <= 375 ? 80 : 160,
                                  decoration: BoxDecoration(
                                      color: _backgroundColorIcon,
                                      borderRadius: BorderRadius.circular(100)),
                                  padding: EdgeInsets.all(28),
                                  child: SvgPicture.asset(
                                    _icon as String,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),

                                Text(_title!,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            fontSize:
                                                screenWidth <= 375 ? 28 : 40,
                                            color: Colors.white)
                                        .copyWith(
                                      shadows: [
                                        Shadow(
                                          blurRadius: 3.0,
                                          color: Colors.black.withOpacity(.25),
                                          offset: Offset(
                                            0,
                                            5.0,
                                          ),
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height: 20,
                                ),

                                Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.13,
                                  child: AutoSizeText(_firstText!,
                                      maxLines: 4,
                                      style: Theme.of(context).textTheme.subtitle1!
                                          .copyWith(
                                              fontSize:
                                                  screenWidth <= 375 ? 14 : 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400)
                                          .copyWith(shadows: [
                                        Shadow(
                                          blurRadius: 3.0,
                                          color: Colors.black.withOpacity(.25),
                                          offset: Offset(
                                            0,
                                            5.0,
                                          ),
                                        ),
                                      ])),
                                ),

                                SizedBox(
                                  height: 20,
                                ),

                                if(_secondTextPt2 == null)...[
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.1,
                                    child: AutoSizeText(_secondText!,
                                        maxLines: 2,
                                        maxFontSize: 18,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                            fontSize:
                                            screenWidth <= 375 ? 16 : 23,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)
                                            .copyWith(
                                          shadows: [
                                            Shadow(
                                              blurRadius: 3.0,
                                              color: Colors.black.withOpacity(.25),
                                              offset: Offset(
                                                0,
                                                5.0,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ]else if(_secondTextPt2 != null)...[
                                  Container(
                                    height: MediaQuery.of(context).size.height
                                        * 0.08,
                                    child: AutoSizeText("$_secondText\n$_secondTextPt2",
                                        maxLines: 2,
                                        maxFontSize: 18,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                            fontSize:
                                            screenWidth <= 375 ? 16 : 23,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)
                                            .copyWith(
                                          shadows: [
                                            Shadow(
                                              blurRadius: 3.0,
                                              color: Colors.black.withOpacity(.25),
                                              offset: Offset(
                                                0,
                                                5.0,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ]
                              ],
                            ),
                            SizedBox(
                                height: MediaQuery.of(context).size.height > 850
                                    ? MediaQuery.of(context).size.height * 0.1
                                    : 0),
                            Column(
                              children: [

                                //CHECKBOX dont show again page if type == person
                                if(widget.args["type"] == 'personal')...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Checkbox(
                                          side: BorderSide(color: Colors.white),
                                          value: dontShowAgainRegenerationGamePega,
                                          checkColor: Colors.white,
                                          fillColor:  MaterialStateProperty.all(Colors.transparent),
                                          activeColor: Colors.white,
                                          onChanged: (value) {
                                            prefs!.setBool('dontShowAgainRegenerationGamePega', !dontShowAgainRegenerationGamePega);
                                            setState(() {
                                              dontShowAgainRegenerationGamePega = !dontShowAgainRegenerationGamePega;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          AppLocalizations.of(context)!.dontShowThisMessageAgain,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                ],

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: screenWidth <= 375 ? 45 : 53,
                                        child: TextButton(
                                          style: ButtonStyle(
                                            alignment: Alignment.center,
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40.0),
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context)!.close,
                                            style: TextStyle(
                                                color: Colors.black87
                                                    .withOpacity(.6),
                                                fontSize:
                                                    screenWidth <= 375 ? 14 : 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            if(widget.args["type"] == 'personal'){
                                              SmartPageController controller = SmartPageController.getInstance();
                                              controller.showBottomNavigationBar();
                                              setState(() {
                                                controller.currentBottomIndex = 30;
                                                controller.refreshViews();
                                              });

                                            }else{
                                              SmartPageController controller = SmartPageController.getInstance();
                                              controller.currentBottomIndex = 0;
                                              controller
                                                  .showBottomNavigationBar();
                                              controller.refreshViews();
                                            }
                                          }

                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 28,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        height: screenWidth <= 375 ? 45 : 53,
                                        child: TextButton(
                                          style: ButtonStyle(
                                              alignment: Alignment.center,
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xFF003694)),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40.0),
                                              ))),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .learnMore,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    screenWidth <= 375 ? 14 : 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () async {
                                            SmartPageController controller = SmartPageController.getInstance();
                                            controller.selectBottomTab(1);
                                            // if(widget.args["type"] == 'per
                                            // sonal'){
                                            //Navigator.of(context).pop();
                                            // }else{
                                            //   Navigator.of(context).pop();
                                            //   if (welcomeGuideLearningTrack == null)
                                            //   {
                                            //     welcomeGuideLearningTrack =
                                            //     await learningTracksStore
                                            //         .getWelcomeGuide();
                                            //   }
                                            //   else if (welcomeGuideLearningTrack !=
                                            //       null)
                                            //   {
                                            //     openLearningTrack(
                                            //         welcomeGuideLearningTrack!);
                                            //   }
                                            // }


                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 25,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, right: 16),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      _imageRights as String,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void openLearningTrack(LearningTracksModel learningTrack) =>
  //     controller.insertPage(ViewLearningTracksScreen(
  //       {
  //         'list_chapters': learningTrack.chapters,
  //         'learning_tracks': learningTrack,
  //         'updateLearningTrack': updateWidget,
  //       },
  //     ));
  //
  // updateWidget() {
  //   setState(() {});
  // }
}
