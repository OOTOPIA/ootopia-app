import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/components/photo_edit.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:provider/provider.dart';
import '../../shared/analytics.server.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

import 'register_second_phase/register_second_phase_controller.dart';

class RegisterPhase2Page extends StatefulWidget {
  final Map<String, dynamic>? args;

  RegisterPhase2Page([this.args]);
  @override
  _RegisterPhase2PageState createState() => _RegisterPhase2PageState();
}

class _RegisterPhase2PageState extends State<RegisterPhase2Page> {
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  late AuthStore authStore;
  RegisterSecondPhaseController controller =
      RegisterSecondPhaseController.getInstance();

  @override
  void initState() {
    super.initState();
    this.trackingEvents.signupStartedSignupPartII();
  }

  setAuthStoreToController() {
    if (controller.user == null) {
      controller.authStore = authStore;
      controller.user = authStore.currentUser;
    }
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
    authStore = Provider.of<AuthStore>(context);
    setAuthStoreToController();

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
                  child: Form(
                    key: controller.formKey,
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
                              photoPath: controller.user!.photoFilePath,
                              updatePhoto: (String? ImagePath) {
                                if (ImagePath != null) {
                                  controller.getImage(
                                    ImagePath,
                                  );
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
                              autocorrect: false,
                              enableSuggestions: false,
                              controller: controller.bioController,
                              maxLines: 5,
                              decoration: GlobalConstants.of(context)
                                  .loginInputTheme(
                                      AppLocalizations.of(context)!.optional)
                                  .copyWith(alignLabelWithHint: true),
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
                                  controller.countryCode =
                                      number.isoCode.toString();
                                });
                                controller.getPhoneNumber(number.toString(),
                                    number.isoCode.toString());
                              },
                              onInputValidated: (bool value) {
                                setState(() {
                                  controller.validCellPhone = !value;
                                });
                              },
                              selectorConfig: SelectorConfig(
                                selectorType:
                                    PhoneInputSelectorType.BOTTOM_SHEET,
                                leadingPadding: 18,
                                trailingSpace: false,
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.contains('+')) {
                                  return AppLocalizations.of(context)!
                                      .mobilephoneToExperience;
                                } else if (controller.validCellPhone) {
                                  return AppLocalizations.of(context)!
                                      .insertValidCellPhone;
                                }
                                return null;
                              },
                              textFieldController:
                                  controller.cellPhoneController,
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
                                    controller: controller.dayController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 2,
                                    autofocus: false,
                                    decoration: GlobalConstants.of(context)
                                        .loginInputTheme('')
                                        .copyWith(
                                            label: Center(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .day),
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
                                    controller: controller.monthController,
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
                                    controller: controller.yearController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                    autofocus: false,
                                    onChanged: (String text) {
                                      controller.birthdateIsValid(
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
                                              AppLocalizations.of(context)!
                                                  .year),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: controller
                                  .birthdateValidationErrorMessage!.isNotEmpty,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top:
                                      GlobalConstants.of(context).spacingNormal,
                                  bottom:
                                      GlobalConstants.of(context).spacingSmall,
                                ),
                                child: Text(
                                  controller.birthdateValidationErrorMessage
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
                            bottom: GlobalConstants.of(context).spacingLarge,
                          ),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          side: BorderSide.none)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xff003694)),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.all(
                                              GlobalConstants.of(context)
                                                  .spacingNormal))),
                              child: Observer(
                                builder: (_) => SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .continueAccess,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (!controller.formKey.currentState!
                                    .validate()) return;

                                controller.storeDataUserFirstStep();

                                if (!controller.birthDateIsValid()) return;

                                if (controller.firstStepIsValid(context))
                                  Navigator.of(context).pushNamed(
                                      PageRoute
                                          .Page
                                          .registerPhase2DailyLearningGoalScreen
                                          .route,
                                      arguments: {
                                        "user": authStore.currentUser,
                                        "returnToPageWithArgs":
                                            widget.args!["returnToPageWithArgs"]
                                      });
                              }),
                        )
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
