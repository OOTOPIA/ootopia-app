import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/utils/circle-painter.dart';
import 'package:ootopia_app/screens/auth/register_phase_2_daily_learning_goal_screen.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class RegisterPhase2Page extends StatefulWidget {
  @override
  _RegisterPhase2PageState createState() => _RegisterPhase2PageState();
}

class _RegisterPhase2PageState extends State<RegisterPhase2Page>
    with SecureStoreMixin {
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File _image;
  final picker = ImagePicker();
  User user;
  String birthdateValidationErrorMessage = "";

  // DateTime selectedDate = DateTime.now();

  // _selectDate(BuildContext context, [bool showYearFirst = false]) async {
  //   final DateTime picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //     initialDatePickerMode:
  //         showYearFirst ? DatePickerMode.year : DatePickerMode.day,
  //   );
  //   if (picked != null && picked != selectedDate)
  //     setState(() {
  //       selectedDate = picked;
  //     });
  // }

  Future getLoggedUser() async {
    setState(() {
      getCurrentUser().then((value) {
        user = value;
      });
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        user.photoFilePath = pickedFile.path;
      }
    });
  }

  bool _birthdateIsValid() {
    try {
      DateTime now = DateTime.now();
      int day = int.parse(_dayController.text);
      int month = int.parse(_monthController.text);
      int year = int.parse(_yearController.text);
      return _dayController.text.length == 2 &&
          _monthController.text.length == 2 &&
          _yearController.text.length == 4 &&
          day <= 31 &&
          month <= 12 &&
          year >= 1900 &&
          year < now.year;
    } catch (error) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    getLoggedUser();
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
                                  child: GestureDetector(
                                    onTap: () {
                                      getImage();
                                    },
                                    child: CustomPaint(
                                      painter: CirclePainter(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: _image == null
                                            ? Image.asset(
                                                'assets/icons/profile_large.png',
                                                width: 36,
                                              )
                                            : CircleAvatar(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          300),
                                                  child: Image.file(
                                                    _image,
                                                    fit: BoxFit.cover,
                                                    width: 140,
                                                    height: 140,
                                                  ),
                                                ),
                                                radius: 300,
                                              ),
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
                                            getImage();
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
                                  maxLength: 2,
                                  autofocus: false,
                                  decoration: GlobalConstants.of(context)
                                      .loginInputTheme('day'),
                                  onChanged: (String text) {
                                    if (text.length == 2 &&
                                        int.parse(text) <= 31) {
                                      node.nextFocus();
                                    }
                                  },
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
                                  maxLength: 2,
                                  autofocus: false,
                                  decoration: GlobalConstants.of(context)
                                      .loginInputTheme('month'),
                                  onChanged: (String text) {
                                    if (text.length == 2 &&
                                        int.parse(text) <= 12) {
                                      node.nextFocus();
                                    }
                                  },
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
                                  maxLength: 4,
                                  autofocus: false,
                                  onChanged: (String text) {
                                    if (text.length == 4 &&
                                        int.parse(text) >= 1900) {
                                      node.nextFocus();
                                    }
                                  },
                                  decoration: GlobalConstants.of(context)
                                      .loginInputTheme('year'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: birthdateValidationErrorMessage.isNotEmpty,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: GlobalConstants.of(context).spacingNormal,
                              bottom: GlobalConstants.of(context).spacingSmall,
                            ),
                            child: Text(
                              birthdateValidationErrorMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
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
                              "Confirm",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (_birthdateIsValid()) {
                              setState(() {
                                birthdateValidationErrorMessage = "";
                              });
                              user.birthdate =
                                  "${_yearController.text}-${_monthController.text}-${_dayController.text}";
                              Navigator.of(context).pushNamed(
                                PageRoute
                                    .Page
                                    .registerPhase2DailyLearningGoalScreen
                                    .route,
                                arguments: {"user": user},
                              );
                            } else {
                              setState(() {
                                String day = _dayController.text;
                                String month = _monthController.text;
                                String year = _yearController.text;
                                if (day.length < 2 ||
                                    month.length < 2 ||
                                    year.length < 4) {
                                  birthdateValidationErrorMessage =
                                      "Please enter a valid birthdate in format DD/MM/YYYY";
                                } else {
                                  birthdateValidationErrorMessage =
                                      "Please enter a valid birthdate";
                                }
                              });
                            }
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
