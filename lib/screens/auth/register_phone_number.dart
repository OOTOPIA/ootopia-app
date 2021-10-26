import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/components/photo_edit.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:smart_page_navigation/smart_page_navigation.dart';

import 'package:ootopia_app/screens/auth/register_controller/register_controller.dart';

class RegisterPhoneNumberScreen extends StatefulWidget {
  final Map<String, dynamic>? args;

  RegisterPhoneNumberScreen([this.args]);

  @override
  _RegisterPhoneNumberScreenState createState() =>
      _RegisterPhoneNumberScreenState();
}

class _RegisterPhoneNumberScreenState extends State<RegisterPhoneNumberScreen> {
  RegisterSecondPhaseController registerController =
      RegisterSecondPhaseController.getInstance();
  SmartPageController pageController = SmartPageController.getInstance();

  @override
  void initState() {
    super.initState();
  }

  get appBar => AppBar(
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.all(3),
          child: Image.asset(
            'assets/images/logo.png',
            height: 34,
          ),
        ),
        toolbarHeight: 45,
        elevation: 2,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        brightness: Brightness.light,
        leading: Padding(
          padding: EdgeInsets.only(
            left: GlobalConstants.of(context).screenHorizontalSpace - 9,
          ),
          child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Row(
                    children: [
                      Icon(
                        FeatherIcons.arrowLeft,
                        color: Colors.black,
                        size: 20,
                      ),
                      Text(
                        AppLocalizations.of(context)!.back,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ))),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: appBar,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: GlobalConstants.of(context).screenHorizontalSpace),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 32,
                          ),
                          PhotoEdit(
                            photoPath: registerController.user!.photoFilePath,
                            updatePhoto: (String? ImagePath) {
                              if (ImagePath != null) {
                                registerController.getImage(
                                    ImagePath, () => setState(() {}));
                              }
                            },
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(AppLocalizations.of(context)!.bio,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff7F7F7F),
                                    fontWeight: FontWeight.w500)),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            autocorrect: true,
                            enableSuggestions: true,
                            textCapitalization: TextCapitalization.sentences,
                            controller: registerController.bioController,
                            maxLines: 5,
                            decoration: GlobalConstants.of(context)
                                .loginInputTheme(
                                    AppLocalizations.of(context)!.optional)
                                .copyWith(
                                    alignLabelWithHint: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16)),
                            validator: (value) => null,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  AppLocalizations.of(context)!.mobilePhone,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff7F7F7F),
                                      fontWeight: FontWeight.w500))),
                          SizedBox(
                            height: 16,
                          ),
                          InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
                              setState(() {
                                registerController.countryCode =
                                    number.isoCode.toString();
                              });
                              registerController.getPhoneNumber(
                                  number.toString(), number.isoCode.toString());
                            },
                            onInputValidated: (bool value) {
                              setState(() {
                                registerController.validCellPhone = !value;
                              });
                            },
                            selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                              leadingPadding: 18,
                              trailingSpace: false,
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.contains('+')) {
                                return AppLocalizations.of(context)!
                                    .mobilephoneToExperience;
                              } else if (registerController.validCellPhone) {
                                return AppLocalizations.of(context)!
                                    .insertValidCellPhone;
                              }
                              return null;
                            },
                            textFieldController:
                                registerController.cellPhoneController,
                            formatInput: true,
                            errorMessage: AppLocalizations.of(context)!
                                .mobilephoneToExperience,
                            inputBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(width: 0.25),
                            ),
                            scrollPadding: EdgeInsets.all(0),
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            inputDecoration: InputDecoration(
                              errorMaxLines: 4,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(width: 0.25),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(width: 0.25),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 0.25, color: Color(0xff8E1816)),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 0.25, color: Color(0xff8E1816)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  AppLocalizations.of(context)!.dateOfBirth,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff7F7F7F),
                                      fontWeight: FontWeight.w500))),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller: registerController.dayController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 2,
                                  autofocus: false,
                                  decoration: GlobalConstants.of(context)
                                      .loginInputTheme('')
                                      .copyWith(
                                          label: Center(
                                        child: Text(
                                            AppLocalizations.of(context)!.day),
                                      )),
                                  onChanged: (String text) {
                                    if (text.length == 2 &&
                                        int.parse(text) <= 31) {
                                      node.nextFocus();
                                    }
                                  },
                                  onEditingComplete: () => node.nextFocus(),
                                ),
                              ),
                              SizedBox(
                                width: GlobalConstants.of(context)
                                    .screenHorizontalSpace,
                              ),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller:
                                      registerController.monthController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 2,
                                  autofocus: false,
                                  decoration: GlobalConstants.of(context)
                                      .loginInputTheme('')
                                      .copyWith(
                                          label: Center(
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .month),
                                      )),
                                  onChanged: (String text) {
                                    if (text.length == 2 &&
                                        int.parse(text) <= 12) {
                                      node.nextFocus();
                                    }
                                  },
                                  onEditingComplete: () => node.nextFocus(),
                                ),
                              ),
                              SizedBox(
                                width: GlobalConstants.of(context)
                                    .screenHorizontalSpace,
                              ),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller: registerController.yearController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 4,
                                  autofocus: false,
                                  onChanged: (String text) {
                                    registerController.birthdateIsValid(
                                        context, () => setState(() {}));
                                    if (text.length == 4 &&
                                        int.parse(text) >= 1900) {
                                      node.nextFocus();
                                    }
                                  },
                                  decoration: GlobalConstants.of(context)
                                      .loginInputTheme('')
                                      .copyWith(
                                          label: Center(
                                        child: Text(
                                            AppLocalizations.of(context)!.year),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: registerController
                                .birthdateValidationErrorMessage!.isNotEmpty,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: GlobalConstants.of(context).spacingNormal,
                                bottom:
                                    GlobalConstants.of(context).spacingSmall,
                              ),
                              child: Text(
                                registerController
                                    .birthdateValidationErrorMessage
                                    .toString(),
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
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 24,
                        ),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                        side: BorderSide.none)),
                                minimumSize: MaterialStateProperty.all(
                                  Size(60, 55),
                                ),
                                elevation:
                                    MaterialStateProperty.all<double>(0.0),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xff003694)),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(GlobalConstants.of(context)
                                        .spacingNormal))),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.continueAccess,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () {
                              registerController.setBirthDateAndCountryCode();

                              if (registerController.firstStepIsValid(context))
                                Navigator.of(context).pushNamed(
                                  PageRoute.Page.registerDailyLearningGoalScreen
                                      .route,
                                );
                            }),
                      )
                    ],
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
