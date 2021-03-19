import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/auth/register_phase_2_geolocation.dart';
import 'package:ootopia_app/shared/global-constants.dart';

class RegisterPhase2DailyLearningGoalPage extends StatefulWidget {
  final User user;

  RegisterPhase2DailyLearningGoalPage(this.user);

  @override
  _RegisterPhase2DailyLearningGoalPageState createState() =>
      _RegisterPhase2DailyLearningGoalPageState();
}

class _RegisterPhase2DailyLearningGoalPageState
    extends State<RegisterPhase2DailyLearningGoalPage> {
  final _formKey = GlobalKey<FormState>();
  double _learningGoalRating = 10;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.user.dailyLearningGoalInMinutes != null &&
          widget.user.dailyLearningGoalInMinutes >= 10) {
        _learningGoalRating = widget.user.dailyLearningGoalInMinutes.toDouble();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
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
                          'Regeneration Game',
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
                          'Set the time for your daily learning goal:',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        SizedBox(
                          height: GlobalConstants.of(context).spacingSmall,
                        ),
                        Slider(
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
                        SizedBox(
                          height: GlobalConstants.of(context).spacingLarge,
                        ),
                        FlatButton(
                          child: Padding(
                            padding: EdgeInsets.all(
                              GlobalConstants.of(context).spacingNormal,
                            ),
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onPressed: () {
                            widget.user.dailyLearningGoalInMinutes =
                                _learningGoalRating.round();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RegisterPhase2GeolocationPage(widget.user),
                              ),
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
