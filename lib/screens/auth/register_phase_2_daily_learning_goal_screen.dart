import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/auth/register_phase_2_geolocation.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPhase2DailyLearningGoalPage extends StatefulWidget {
  Map<String, dynamic> args;
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

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.args['user'].dailyLearningGoalInMinutes != null &&
          widget.args['user'].dailyLearningGoalInMinutes >= 10) {
        _learningGoalRating =
            widget.args['user'].dailyLearningGoalInMinutes.toDouble();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(
                      GlobalConstants.of(context).spacingMedium,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/white_logo.png',
                              height: GlobalConstants.of(context).logoHeight,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: GlobalConstants.of(context).spacingNormal,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context).regenerationGame,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: GlobalConstants.of(context).spacingNormal,
                            bottom: GlobalConstants.of(context).spacingLarge,
                          ),
                          child: SizedBox(
                            height: 200,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                shape: BoxShape.rectangle,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context).setTheTimeForYourDailyLearningGoal,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        SizedBox(
                          height: GlobalConstants.of(context).spacingSmall,
                        ),
                        SliderTheme(
                          data: SliderThemeData(
                            thumbColor: Colors.white,
                            activeTrackColor: Colors.white,
                          ),
                          child: Slider(
                            value: _learningGoalRating,
                            min: 10,
                            max: 60,
                            divisions: 5,
                            onChanged: (newRating) {
                              setState(() {
                                _learningGoalRating = newRating;
                              });
                            },
                            label:
                                "${_learningGoalRating.toStringAsFixed(0)} min.",
                          ),
                        ),
                        SizedBox(
                          height: GlobalConstants.of(context).spacingLarge,
                        ),
                        FlatButton(
                          child: Padding(
                            padding: EdgeInsets.all(
                              GlobalConstants.of(context).spacingNormal,
                            ),
                            child: Text(
                              AppLocalizations.of(context).confirm,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onPressed: () {
                            widget.args['user'].dailyLearningGoalInMinutes =
                                _learningGoalRating.round();

                            this
                                .trackingEvents
                                .signupCompletedStepIIOfSignupII({
                              "dailyLearningGoalInMinutes":
                                  widget.args['user'].dailyLearningGoalInMinutes
                            });
                            Navigator.of(context).pushNamed(
                              PageRoute
                                  .Page.registerPhase2GeolocationScreen.route,
                              arguments: widget.args,
                            );
                          },
                          color: Colors.white,
                          splashColor: Colors.black54,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.white,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ],
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
}
