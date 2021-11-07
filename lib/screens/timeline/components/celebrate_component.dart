import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class Celebration extends StatefulWidget {
  final Map<String, dynamic> args;

  Celebration(this.args);

  @override
  CelebrationStates createState() => CelebrationStates();
}

class CelebrationStates extends State<Celebration> {
  late VideoPlayerController _controller;
  bool videoIsFinished = false;
  late Future<void> _initializeVideoPlayerFuture;
  bool loadingVideo = false;

  void _backButton(BuildContext context) {
    videoIsFinished = false;
    if (widget.args['goal'] == 'invitationCode') {
      Navigator.of(context).pushNamedAndRemoveUntil(
        PageRoute.Page.homeScreen.route,
        (Route<dynamic> route) => false,
        arguments: {
          "returnToPageWithArgs": {
            'currentPageName': widget.args['returnToPageWithArgs']
                ['currentPageName']
          }
        },
      );
    } else {
      Navigator.pop(context);
    }
  }

  isolateLoadingVideo() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _controller = VideoPlayerController.asset(
          'assets/videos/ootopia_celebration_cutter.mp4')
        ..initialize().then((_) {
          Timer(Duration(milliseconds: 300), () {
            _controller.play();
            loadingVideo = true;
          // Initialize the controller and store the Future for later use.
          _initializeVideoPlayerFuture = _controller.initialize();

          // Use the controller to loop the video.
          _controller.setLooping(false);
          });
          
        })
        ..addListener(() {
          setState(() {
            if (_controller.value.isInitialized &&
                2 == _controller.value.position.inSeconds) {
              videoIsFinished = true;
            } else {
              videoIsFinished = false;
            }
            if (_controller.value.isPlaying &&
                _controller.value.isInitialized &&
                2 == _controller.value.position.inSeconds) {
              _controller.pause();
            }
          });
        });
    });
  }

  @override
  void initState() {
    super.initState();
    isolateLoadingVideo();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: loadingVideo
                    ? Container(
                        height: _controller.value.size.height,
                        width: _controller.value.size.width,
                        child: VideoPlayer(_controller),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
              ),
            ),
            if (videoIsFinished)
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          widget.args["goal"] == "invitationCode"
                              ? Text(
                                  AppLocalizations.of(context)!
                                      .welcome
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                      color: Color(0xFF003694)),
                                )
                              : Text(
                                  widget.args["goal"] != "global"
                                      ? AppLocalizations.of(context)!
                                          .congratulations
                                          .toUpperCase()
                                      : AppLocalizations.of(context)!
                                          .letIsCelebrate
                                          .toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth < 360 ? 26 : 32,
                                      color: Color(0xFF003694)),
                                ),
                          if (widget.args["goal"] != "global")
                            Padding(
                                padding: EdgeInsets.only(
                                    top: screenWidth < 360 ? 6 : 8),
                                child: Text(
                                  widget.args["name"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth < 360 ? 22 : 24,
                                      color: Color(0xFF000000)),
                                )),
                          if (widget.args["goal"] == "invitationCode")
                            Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .whyYouReceivdOOz,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xFF000000),
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                          if (widget.args["goal"] == "personal")
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenWidth < 360 ? 4 : 8,
                                  left: 35,
                                  right: 35),
                              child: Text(
                                screenWidth < 360
                                    ? AppLocalizations.of(context)!
                                        .youMetYourDailyGoalToHelpRegenerateThePlanetWithoutParagraphs
                                    : AppLocalizations.of(context)!
                                        .youMetYourDailyGoalToHelpRegenerateThePlanet,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                  fontSize: screenWidth < 360
                                      ? 12
                                      : screenWidth <= 375
                                          ? 15
                                          : 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: screenWidth < 360 ? 33 : 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${widget.args["goal"] == "invitationCode" ? AppLocalizations.of(context)!.welcomeCredit : "OOz " + AppLocalizations.of(context)!.totalBalance}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: widget.args["goal"] ==
                                                  "invitationCode"
                                              ? 20
                                              : screenWidth < 360
                                                  ? 20
                                                  : 24,
                                          color: Color(0xFF003694)),
                                    ),
                                    Container(
                                        height: screenWidth < 360 ? 26 : 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Color(0xFF003694))),
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ImageIcon(
                                                  AssetImage(
                                                      'assets/icons_profile/ootopia.png'),
                                                  color: Color(0xFF003694),
                                                  size: screenWidth < 360
                                                      ? 28
                                                      : 32,
                                                ),
                                                Text(
                                                  widget.args["balance"],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          screenWidth < 360
                                                              ? 14
                                                              : 16,
                                                      color: Color(0xFF003694)),
                                                )
                                              ],
                                            )))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: screenWidth < 360 ? 8 : 10),
                                child: Column(
                                  children: [
                                    if (widget.args["goal"] != "invitationCode")
                                      Text(
                                        widget.args["goal"] == "personal"
                                            ? AppLocalizations.of(context)!
                                                .nextStepIsToHelpMeetYourCityGoal
                                            : AppLocalizations.of(context)!
                                                .nextStepIsToHelpMeetYourGlobalGoal,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize:
                                                screenWidth < 360 ? 14 : 16,
                                            color: Color(0xFF000000)),
                                      ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .keepMakingOOTOPIAAlive,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth < 360 ? 14 : 16,
                                          color: Color(0xFF000000)),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: screenWidth < 360 ? 8 : 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: screenWidth < 360 ? 46 : 58,
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
                                      AppLocalizations.of(context)!.goOn,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => {_backButton(context)},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
