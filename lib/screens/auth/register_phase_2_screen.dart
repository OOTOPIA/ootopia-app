import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/utils/circle-painter.dart';
import 'package:ootopia_app/screens/auth/register_phase_2_daily_learning_goal_screen.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import '../../shared/analytics.server.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class RegisterPhase2Page extends StatefulWidget {
  Map<String, dynamic>? args;

  RegisterPhase2Page([this.args]);
  @override
  _RegisterPhase2PageState createState() => _RegisterPhase2PageState();
}

class _RegisterPhase2PageState extends State<RegisterPhase2Page>
    with SecureStoreMixin {
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();
  User? user;
  String birthdateValidationErrorMessage = "";
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();

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
      if (user != null && pickedFile != null) {
        _image = File(pickedFile.path);
        user!.photoFilePath = pickedFile.path;
      }
    });
  }

  bool _birthdateIsValid() {
    try {
      DateTime now = DateTime.now();
      int day = int.parse(_dayController.text);
      int month = int.parse(_monthController.text);
      int year = int.parse(_yearController.text);
      return _yearController.text.length == 4 &&
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
    this.trackingEvents.signupStartedSignupPartII();
  }

  File? filePath;
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            SizedBox(
              height: 33,
            ),
            Center(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Colors.white,
                          width: 4.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: filePath == null
                          ? CircleAvatar(
                              radius: 57,
                              backgroundImage: AssetImage(
                                  'assets/icons_profile/profile.png'),
                            )
                          : CircleAvatar(
                              radius: 57,
                              backgroundImage: Image.file(
                                filePath!,
                                fit: BoxFit.cover,
                              ).image,
                            ),
                    ),
                  ),
                  Positioned(
                      bottom: 7,
                      right: 37,
                      child: InkWell(
                        onTap: () async {
                          final ImagePicker _picker = ImagePicker();
                          // Pick an image
                          final image = await _picker.getImage(
                              source: ImageSource.gallery);

                          final File file = File(image!.path);
                          setState(() {
                            filePath = file;
                          });
                        },
                        child: Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            border: new Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                              backgroundColor: Color(0xff03DAC5),
                              radius: 20,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 22,
                                color: Colors.white,
                              )),
                        ),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 22,
            ),
            Text(
              AppLocalizations.of(context)!.bio,
              style: TextStyle(fontSize: 18, color: Color(0xff7F7F7F)),
            ),
            SizedBox(
              height: 7,
            ),
            TextFormField(
                maxLines: 5,
                decoration: GlobalConstants.of(context)
                    .loginInputTheme(AppLocalizations.of(context)!.optional)),
            SizedBox(
              height: 20,
            ),
            Text(
              AppLocalizations.of(context)!.mobilePhone,
              style: TextStyle(fontSize: 18, color: Color(0xff7F7F7F)),
            ),
            SizedBox(
              height: 7,
            ),
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              onInputValidated: (bool value) {
                setState(() {});
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.mobilephoneToExperience;
                }
                return null;
              },
              formatInput: true,
              errorMessage:
                  AppLocalizations.of(context)!.mobilephoneToExperience,
              inputBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(width: 0.25),
              ),
              scrollPadding: EdgeInsets.all(0),
              autoValidateMode: AutovalidateMode.onUserInteraction,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputDecoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(width: 0.25),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(width: 0.25),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(width: 0.25, color: Color(0xff8E1816)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(width: 0.25, color: Color(0xff8E1816)),
                ),
              ),
            ),
            SizedBox(
              height: 22,
            ),
            Text(
              AppLocalizations.of(context)!.dateOfBirth,
              style: TextStyle(fontSize: 18, color: Color(0xff7F7F7F)),
            ),
            SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: GlobalConstants.of(context).spacingSmall,
                    ),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _dayController,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      autofocus: false,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: GlobalConstants.of(context)
                          .loginInputTheme(AppLocalizations.of(context)!.day),
                      onChanged: (String text) {
                        if (text.length == 2 && int.parse(text) <= 31) {
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
                      left: GlobalConstants.of(context).spacingSmall,
                    ),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _monthController,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      autofocus: false,
                      decoration: GlobalConstants.of(context)
                          .loginInputTheme(AppLocalizations.of(context)!.month),
                      onChanged: (String text) {
                        if (text.length == 2 && int.parse(text) <= 12) {
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
                      left: GlobalConstants.of(context).spacingSmall,
                    ),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      autofocus: false,
                      onChanged: (String text) {
                        if (text.length == 4 && int.parse(text) >= 1900) {
                          node.nextFocus();
                        }
                      },
                      decoration: GlobalConstants.of(context)
                          .loginInputTheme(AppLocalizations.of(context)!.year),
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
                    EdgeInsets.all(GlobalConstants.of(context).spacingNormal)),
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
                Navigator.of(context).pushNamed(
                  PageRoute.Page.registerPhase2DailyLearningGoalScreen.route,
                  arguments: {
                    "user": user,
                    "returnToPageWithArgs":
                        widget.args!["returnToPageWithArgs"],
                  },
                );
                // if (_birthdateIsValid()) {
                //   setState(() {
                //     birthdateValidationErrorMessage = "";
                //   });
                //   this.trackingEvents.signupCompletedStepIOfSignupII(
                //       {"havePhoto": _image != null ? true : false});

                //   user!.birthdate =
                //       "${_yearController.text}-${_monthController.text}-${_dayController.text}";

                // } else {
                //   setState(() {
                //     String year = _yearController.text;
                //     if (year.length < 4) {
                //       birthdateValidationErrorMessage =
                //           AppLocalizations.of(context)!
                //               .pleaseEnterAValidBirthdateInFormat;
                //     } else {
                //       birthdateValidationErrorMessage =
                //           AppLocalizations.of(context)!
                //               .pleaseEnterAValidBirthdate;
                //     }
                //   });
                // }
              },
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
