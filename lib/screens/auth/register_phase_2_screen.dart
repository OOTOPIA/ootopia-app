import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ootopia_app/data/utils/circle-painter.dart';
import 'package:ootopia_app/screens/auth/register_phase_2_daily_learning_goal_screen.dart';
import 'package:ootopia_app/shared/global-constants.dart';

class RegisterPhase2Page extends StatefulWidget {
  @override
  _RegisterPhase2PageState createState() => _RegisterPhase2PageState();
}

class _RegisterPhase2PageState extends State<RegisterPhase2Page> {
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context, [bool showYearFirst = false]) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDatePickerMode:
          showYearFirst ? DatePickerMode.year : DatePickerMode.day,
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
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
                        Center(
                          child: SizedBox(
                            width: 140,
                            height: 140,
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 140,
                                  height: 140,
                                  child: CustomPaint(
                                    painter: CirclePainter(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Image.asset(
                                        'assets/icons/profile_large.png',
                                        width: 36,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: CustomPaint(
                                        painter: CirclePainter(),
                                        child: IconButton(
                                          icon: SvgPicture.asset(
                                              'assets/icons/add_without_border.svg'),
                                          color: Colors.white,
                                          onPressed: () {
                                            print("clicou");
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: GlobalConstants.of(context).spacingLarge,
                          ),
                        ),
                        Text(
                          'Date of Birth',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: GlobalConstants.of(context).spacingNormal,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      GlobalConstants.of(context).spacingSmall,
                                ),
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller: _dayController,
                                  keyboardType: TextInputType.number,
                                  autofocus: false,
                                  decoration: GlobalConstants.of(context)
                                      .registerBirthdateInputTheme('day'),
                                  onEditingComplete: () => node.nextFocus(),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      GlobalConstants.of(context).spacingSmall,
                                ),
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller: _monthController,
                                  keyboardType: TextInputType.number,
                                  autofocus: false,
                                  decoration: GlobalConstants.of(context)
                                      .registerBirthdateInputTheme('month'),
                                  onEditingComplete: () => node.nextFocus(),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      GlobalConstants.of(context).spacingSmall,
                                ),
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller: _yearController,
                                  keyboardType: TextInputType.number,
                                  autofocus: false,
                                  decoration: GlobalConstants.of(context)
                                      .registerBirthdateInputTheme('year'),
                                ),
                              ),
                            ),
                          ],
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RegisterPhase2DailyLearningGoalPage(),
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
