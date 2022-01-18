import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ootopia_app/data/models/users/link_model.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/screens/components/photo_edit.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/theme/light/colors.dart';
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
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  SmartPageController pageController = SmartPageController.getInstance();
  List<Link> links = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    registerController.validCellPhone = false;
    registerController.exibTextError = false;
    super.dispose();
  }

  get appBar => DefaultAppBar(
        components: [
          AppBarComponents.back,
        ],
        onTapLeading: () {
          Navigator.of(context).pop();
        },
      );

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          BackgroundButterflyTop(positioned: -59),
          Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom == 0,
              child: BackgroundButterflyBottom()),
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Container(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: true,
                    fillOverscroll: true,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              GlobalConstants.of(context).screenHorizontalSpace),
                      child: SingleChildScrollView(
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
                                  updatePhoto: (String? imagePath) {
                                    if (imagePath != null) {
                                      registerController.getImage(
                                          imagePath, () => setState(() {}));
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.optional,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xffd7d7d7),
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 20,
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



                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    AppLocalizations.of(context)!.links,
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: LightColors.grey
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    // dynamic list = await  Navigator.of(context)
                                    //     .pushNamed(
                                    //   PageRoute.Page.addLink.route,
                                    // );
                                    // if(list != null){
                                    //   //TODO ADD/SHOW LINKS
                                    //   print('foi ${list.length}');
                                    // }
                                    dynamic list = await  Navigator.of(context)
                                        .pushNamed(
                                        PageRoute.Page.addLink.route,
                                        arguments: {
                                          "list": links
                                        }
                                    );
                                    if(list != null){
                                      setState(() {
                                        links = list;
                                      });
                                      print(' afoi ${list.length}');
                                    }
                                  },
                                  child: TextFormField(
                                      textCapitalization: TextCapitalization.sentences,
                                      style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      enabled: false,
                                      decoration: GlobalConstants.of(context)
                                          .loginInputTheme(
                                          AppLocalizations.of(context)!.addLinksInYourPage).copyWith(
                                          prefixIcon: Container(
                                            height: 21,
                                            width: 21,
                                            margin: EdgeInsets.all(15),
                                            child: SvgPicture.asset(
                                              'assets/icons/mais.svg',
                                              height: 21,
                                              width: 21,),
                                          ),
                                          labelStyle: TextStyle(color: Colors.black),
                                          alignLabelWithHint: true,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16))),
                                ),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: links.length,
                                  itemBuilder: (context, index) {
                                    return urlItem(links[index]);
                                  },
                                ),
                                SizedBox(
                                  height: 16,
                                ),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(AppLocalizations.of(context)!.mobilePhone,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xff7F7F7F),
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.required,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xffd7d7d7),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
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
                                        number.toString(),
                                        number.isoCode.toString());
                                  },
                                  onInputValidated: (bool value) {
                                    setState(() {
                                      registerController.validCellPhone = value;
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
                                    } else if (!registerController.validCellPhone) {
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
                                    fillColor: Colors.white.withOpacity(0.7),
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(AppLocalizations.of(context)!.dateOfBirth,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xff7F7F7F),
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.optional,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xffd7d7d7),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
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
                                        controller:
                                            registerController.dayController,
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
                                          registerController.birthdateIsValid(
                                              context, () => setState(() {}));
                                          if (text.length == 2 &&
                                              int.parse(text) <= 31) {
                                            node.nextFocus();
                                          } else {
                                            registerController.exibTextError = true;
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
                                          registerController.birthdateIsValid(
                                              context, () => setState(() {}));
                                          if (text.length == 2 &&
                                              int.parse(text) <= 12) {
                                            node.nextFocus();
                                          } else {
                                            registerController.exibTextError = true;
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
                                            registerController.yearController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        autofocus: false,
                                        onChanged: (String text) {
                                          registerController.birthdateIsValid(
                                              context, () => setState(() {}));
                                          if (text.length == 4 &&
                                              int.parse(text) >= 1900) {
                                            node.nextFocus();
                                          } else {
                                            registerController.exibTextError = true;
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
                                  visible: registerController.exibTextError,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top:
                                          GlobalConstants.of(context).spacingNormal,
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
                                        registerController.firstStepIsValid()
                                            ? Color((0xff003694))
                                            : Color(0xff5d7fbb),
                                      ),
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              EdgeInsets.all(
                                                  GlobalConstants.of(context)
                                                      .spacingNormal))),
                                  child: SizedBox(
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
                                  onPressed: registerController.firstStepIsValid()
                                      ? () {
                                          registerController
                                              .setBirthDateAndCountryCode();
                                          this
                                              .trackingEvents
                                              .signupCompletedPhoneNumber({
                                            "phoneNumber": registerController
                                                .cellPhoneController.text
                                          });
                                          Navigator.of(context).pushNamed(
                                            PageRoute
                                                .Page
                                                .registerDailyLearningGoalScreen
                                                .route,
                                          );
                                        }
                                      : null),
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
        ],
      ),
    );
  }

  Widget urlItem(Link link) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Row(
        children: [
          SizedBox(width: 35),
          Container(
            height: 9,
            width: 9,
            decoration: BoxDecoration(
                color: Color(0xff03DAC5),
                shape: BoxShape.circle
            ),
          ),
          SizedBox(width: 8),
          Container(
            width: MediaQuery.of(context).size.width - 101,
            child: Text('${link.title}: ${link.URL}',
              maxLines: 1,
              style: TextStyle(
                  fontSize: 16,
                  color: LightColors.grey


              ),),
          ),
        ],
      ),
    );
  }
}
