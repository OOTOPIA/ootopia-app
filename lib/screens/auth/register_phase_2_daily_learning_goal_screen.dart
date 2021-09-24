import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_player/video_player.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class RegisterPhase2DailyLearningGoalPage extends StatefulWidget {
  final Map<String, dynamic> args;
  RegisterPhase2DailyLearningGoalPage(this.args);

  @override
  _RegisterPhase2DailyLearningGoalPageState createState() =>
      _RegisterPhase2DailyLearningGoalPageState();
}

class _RegisterPhase2DailyLearningGoalPageState
    extends State<RegisterPhase2DailyLearningGoalPage> {
  final _formKey = GlobalKey<FormState>();
  double _learningGoalRating = 10;
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  late VideoPlayerController _videoPlayerController;
  bool _isNotLearningGoalRating = false;
  Timer? timerOpacity;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.asset('assets/videos/ootopia_learning.mp4')
          ..initialize().then((value) {
            _videoPlayerController.play();
            setState(() {});
          });

    setState(() {
      if (widget.args['user'].dailyLearningGoalInMinutes != null &&
          widget.args['user'].dailyLearningGoalInMinutes >= 10) {
        _learningGoalRating =
            widget.args['user'].dailyLearningGoalInMinutes.toDouble();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(
              GlobalConstants.of(context).spacingMedium,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.regenerationGame,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  AppLocalizations.of(context)!.watchVideoToLearn,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: GlobalConstants.of(context).spacingNormal,
                    bottom: GlobalConstants.of(context).spacingLarge,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _videoPlayerController.value.isPlaying
                            ? _videoPlayerController.pause()
                            : _videoPlayerController.play();

                        timerOpacity?.cancel();
                        timerOpacity = Timer(Duration(seconds: 1),
                            () => setState(() => timerOpacity = null));
                      });
                    },
                    child: Container(
                        height: _videoPlayerController.value.size.height,
                        width: _videoPlayerController.value.size.width,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: VideoPlayer(_videoPlayerController),
                            ),
                            AnimatedOpacity(
                              opacity: timerOpacity != null ? 1 : 0.0,
                              duration: Duration(milliseconds: 200),
                              child: timerOpacity != null
                                  ? Center(
                                      child: Icon(
                                        (_videoPlayerController.value.isPlaying
                                            ? Icons.pause_circle_outline
                                            : Icons.play_circle_outline),
                                        size: 64,
                                        color: Colors.black87,
                                      ),
                                    )
                                  : IgnorePointer(
                                      child: Center(
                                        child: Icon(
                                          (_videoPlayerController
                                                  .value.isPlaying
                                              ? Icons.pause_circle_outline
                                              : Icons.play_circle_outline),
                                          size: 64,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                            )
                          ],
                        )),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.chooseYourDailyGoal,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(
                  height: GlobalConstants.of(context).spacingSmall,
                ),
                Text(
                  AppLocalizations.of(context)!.minutesPerDay,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
                SizedBox(
                  height: GlobalConstants.of(context).spacingSmall,
                ),
                SfSliderTheme(
                  data: SfSliderThemeData(
                      activeTrackColor: Color(0xff03DAC5).withOpacity(0.1),
                      inactiveTrackColor: Color(0xff03DAC5),
                      inactiveDividerRadius: 5,
                      minorTickSize: Size(20, 20),
                      tickSize: Size(12, 20),
                      thumbColor: Colors.white,
                      activeDividerColor: Color(0xff03DAC5).withOpacity(0.1),
                      activeTickColor: Color(0xff03DAC5).withOpacity(0.1),
                      overlayColor: Color(0xff03DAC5),
                      activeDividerStrokeColor: Color(0xff03DAC5),
                      disabledActiveDividerColor: Color(0xff03DAC5),
                      thumbStrokeColor: Color(0xff03DAC5),
                      inactiveTickColor: Color(0xff03DAC5),
                      disabledThumbColor: Color(0xff03DAC5),
                      activeMinorTickColor: Color(0xff03DAC5),
                      inactiveDividerColor: Color(0xff03DAC5),
                      overlayRadius: 20,
                      activeDividerStrokeWidth: 20,
                      inactiveDividerStrokeWidth: 20,
                      inactiveTrackHeight: 9,
                      trackCornerRadius: 9,
                      tickOffset: Offset(20, 20)),
                  child: SfSlider(
                    min: 0.0,
                    max: 60,
                    interval: 10,
                    stepSize: 10,
                    showLabels: true,
                    showDividers: true,
                    enableTooltip: true,
                    inactiveColor: Color(0xff03DAC5).withOpacity(0.3),
                    onChanged: (dynamic value) {
                      setState(() {});
                    },
                    value: 20,
                  ),
                ),
                _isNotLearningGoalRating
                    ? SizedBox(
                        height: GlobalConstants.of(context).spacingLarge,
                      )
                    : Container(),
                _isNotLearningGoalRating
                    ? Text(
                        AppLocalizations.of(context)!.isNotLearningGoalRating,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1,
                      )
                    : Container(),
                SizedBox(
                  height: GlobalConstants.of(context).spacingLarge,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide.none),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xff003694)),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(
                            GlobalConstants.of(context).spacingNormal)),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.continueAccess,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    _videoPlayerController.dispose();
                    widget.args['user'].dailyLearningGoalInMinutes =
                        _learningGoalRating.round();

                    this.trackingEvents.signupCompletedStepIIOfSignupII({
                      "dailyLearningGoalInMinutes":
                          widget.args['user'].dailyLearningGoalInMinutes
                    });
                    Navigator.of(context).pushNamed(
                      PageRoute.Page.registerPhase2GeolocationScreen.route,
                      arguments: widget.args,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
