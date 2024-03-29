import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/screens/auth/components/slogan.dart';
import 'package:ootopia_app/screens/auth/register_controller/register_controller.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';

import 'package:ootopia_app/theme/light/colors.dart';
import 'package:ootopia_app/data/utils/circle-painter.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class RegisterFormScreen extends StatefulWidget {
  final Map<String, dynamic>? args;

  RegisterFormScreen([this.args]);

  @override
  _RegisterFormScreenState createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  bool _termsCheckbox = false;
  bool termsOpened = false;
  bool isLoading = false;
  bool showCheckBoxError = false;
  bool _showPassword = false;
  bool _showRepeatPassword = false;

  RegisterSecondPhaseController registerController =
      RegisterSecondPhaseController.getInstance();
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  GlobalKey<FormState> formRegister = GlobalKey<FormState>();

  bool nameIsValid = true;
  bool mailIsValid = true;
  bool passIsValid = true;
  bool pass2IsValid = true;

  void updateTermsCheck() {
    setState(() {
      _termsCheckbox = !_termsCheckbox;
    });
  }

  openTermsOfUse() async {
    Navigator.of(context).pushNamed(
      PageRoute.Page.termsOfUseScreen.route,
      arguments: {
        'filename': 'terms_of_use',
        'onAccept': () {
          setState(() {
            _termsCheckbox = true;
          });
        }
      },
    );
  }

  openPrivacyPolicy() async {
    Navigator.of(context).pushNamed(
      PageRoute.Page.termsOfUseScreen.route,
      arguments: {
        'filename': 'privacy_policy',
        'onAccept': () {
          setState(() {
            _termsCheckbox = true;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _termsCheckbox = false;
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
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _form(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                            GlobalConstants.of(context).spacingMedium),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  elevation: MaterialStateProperty.all<double>(0.0),
                                  minimumSize: MaterialStateProperty.all(
                                    Size(60, 58),
                                  ),
                                  backgroundColor: _termsCheckbox
                                      ? MaterialStateProperty.all(LightColors.blue)
                                      : MaterialStateProperty.all(
                                          Color(0xFF5D7FBB)),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.continueAccess,
                                  style: Theme.of(context)
                                      .inputDecorationTheme
                                      .hintStyle!
                                      .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                onPressed: _termsCheckbox
                                    ? () async {
                                        if (registerController
                                                .emailController.text !=
                                            '') {
                                          await registerController.authStore
                                              .checkEmailExist(registerController
                                                  .emailController.text);
                                        }
                                        if (formRegister.currentState!.validate() &&
                                            !registerController
                                                .authStore.emailExist) {
                                          this.trackingEvents.signupCompletedEmail({
                                            "email": registerController
                                                .emailController.text
                                                .trim(),
                                          });
                                          Navigator.of(context).pushNamed(
                                            PageRoute.Page.registerPhoneNumberScreen
                                                .route,
                                          );
                                        }
                                      }
                                    : () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _form() {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Form(
          key: formRegister,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Slogan(),
                        Padding(
                          padding: EdgeInsets.only(
                            top: GlobalConstants.of(context).spacingMedium,
                            bottom: GlobalConstants.of(context).spacingMedium,
                          ),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: registerController.nameController,
                                keyboardType: TextInputType.name,
                                autocorrect: true,
                                enableSuggestions: true,
                                textCapitalization: TextCapitalization.words,
                                decoration: GlobalConstants.of(context)
                                    .loginInputTheme(
                                        AppLocalizations.of(context)!
                                            .nameAndSurname)
                                    .copyWith(
                                      labelStyle: GoogleFonts.roboto(
                                          color: nameIsValid
                                              ? LightColors.lightGrey
                                              : LightColors.errorRed,
                                          fontWeight: FontWeight.w500),
                                      prefixIcon: ImageIcon(
                                        AssetImage(
                                            "assets/icons/personicon.png"),
                                        color: nameIsValid
                                            ? LightColors.grey
                                            : LightColors.errorRed,
                                        size: 20,
                                      ),
                                    ),
                                validator: (value) {
                                  value = value!.trim();
                                  if (value.isEmpty) {
                                    setState(() {
                                      nameIsValid = false;
                                    });
                                    return AppLocalizations.of(context)!
                                        .pleaseEnterYourNameAndSurname;
                                  }
                                  setState(() {
                                    nameIsValid = true;
                                  });
                                  return null;
                                },
                              ),
                              SizedBox(
                                height:
                                    GlobalConstants.of(context).spacingNormal,
                              ),
                              TextFormField(
                                controller: registerController.emailController,
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                enableSuggestions: false,
                                decoration: GlobalConstants.of(context)
                                    .loginInputTheme(
                                        AppLocalizations.of(context)!.email)
                                    .copyWith(
                                        labelStyle: GoogleFonts.roboto(
                                            color: mailIsValid
                                                ? LightColors.lightGrey
                                                : LightColors.errorRed,
                                            fontWeight: FontWeight.w500),
                                        prefixIcon: ImageIcon(
                                          AssetImage("assets/icons/mail.png"),
                                          color: mailIsValid
                                              ? LightColors.grey
                                              : LightColors.errorRed,
                                          size: 20,
                                        )),
                                validator: (value) {
                                  value = value!.trim();
                                  if (value.isEmpty) {
                                    setState(() {
                                      mailIsValid = false;
                                    });
                                    return AppLocalizations.of(context)!
                                        .pleaseEnterYourValidEmailAddress;
                                  } else if (!EmailValidator.validate(value)) {
                                    setState(() {
                                      mailIsValid = false;
                                    });
                                    return AppLocalizations.of(context)!
                                        .pleaseEnterYourValidEmailAddress;
                                  } else if (registerController
                                      .authStore.emailExist) {
                                    setState(() {
                                      mailIsValid = false;
                                    });
                                    return AppLocalizations.of(context)!
                                        .emailAlreadyRegistered;
                                  }
                                  setState(() {
                                    mailIsValid = true;
                                  });
                                  return null;
                                },
                              ),
                              SizedBox(
                                height:
                                    GlobalConstants.of(context).spacingNormal,
                              ),
                              TextFormField(
                                controller:
                                    registerController.passwordController,
                                obscureText: !_showPassword,
                                autocorrect: false,
                                enableSuggestions: false,
                                decoration: GlobalConstants.of(context)
                                    .loginInputTheme(
                                      AppLocalizations.of(context)!.password,
                                    )
                                    .copyWith(
                                      labelStyle: GoogleFonts.roboto(
                                          color: passIsValid
                                              ? LightColors.lightGrey
                                              : LightColors.errorRed,
                                          fontWeight: FontWeight.w500),
                                      prefixIcon: ImageIcon(
                                        AssetImage("assets/icons/lock.png"),
                                        color: passIsValid
                                            ? LightColors.grey
                                            : LightColors.errorRed,
                                        size: 20,
                                      ),
                                      suffixIcon: GestureDetector(
                                        child: ImageIcon(
                                          _showPassword == false
                                              ? AssetImage(
                                                  "assets/icons/eye-off.png")
                                              : AssetImage(
                                                  "assets/icons/eye.png"),
                                          color: LightColors.grey,
                                          size: 2,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _showPassword = !_showPassword;
                                          });
                                        },
                                      ),
                                    ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    setState(() {
                                      passIsValid = false;
                                    });
                                    return AppLocalizations.of(context)!
                                        .pleaseEnterYourPassword;
                                  }
                                  setState(() {
                                    passIsValid = true;
                                  });
                                  return null;
                                },
                              ),
                              SizedBox(
                                height:
                                    GlobalConstants.of(context).spacingNormal,
                              ),
                              TextFormField(
                                controller:
                                    registerController.repeatPasswordController,
                                obscureText: !_showRepeatPassword,
                                autocorrect: false,
                                enableSuggestions: false,
                                decoration: GlobalConstants.of(context)
                                    .loginInputTheme(
                                      AppLocalizations.of(context)!
                                          .confirmPassword,
                                    )
                                    .copyWith(
                                      labelStyle: GoogleFonts.roboto(
                                          color: pass2IsValid
                                              ? LightColors.lightGrey
                                              : LightColors.errorRed,
                                          fontWeight: FontWeight.w500),
                                      prefixIcon: ImageIcon(
                                        AssetImage("assets/icons/lock.png"),
                                        color: pass2IsValid
                                            ? LightColors.grey
                                            : LightColors.errorRed,
                                        size: 20,
                                      ),
                                      suffixIcon: GestureDetector(
                                        child: ImageIcon(
                                          _showRepeatPassword == false
                                              ? AssetImage(
                                                  "assets/icons/eye-off.png")
                                              : AssetImage(
                                                  "assets/icons/eye.png"),
                                          color: LightColors.grey,
                                          size: 2,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _showRepeatPassword =
                                                !_showRepeatPassword;
                                          });
                                        },
                                      ),
                                    ),
                                validator: (value) {
                                  value = value!.trim();
                                  if (value.isEmpty) {
                                    setState(() {
                                      pass2IsValid = false;
                                    });
                                    return AppLocalizations.of(context)!
                                        .pleaseEnterTheSamePassword;
                                  }
                                  if (value !=
                                      registerController
                                          .passwordController.text) {
                                    setState(() {
                                      pass2IsValid = false;
                                    });
                                    return AppLocalizations.of(context)!
                                        .pleaseEnterTheSamePassword;
                                  }
                                  setState(() {
                                    pass2IsValid = true;
                                  });
                                  return null;
                                },
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: Text(
                                AppLocalizations.of(context)!
                                    .weRespectAndProtectThePrivacyofYourData,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: GlobalConstants.of(context).spacingMedium,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: updateTermsCheck,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        width: 2, color: Colors.black)),
                                child: _termsCheckbox
                                    ? CustomPaint(
                                        painter: CirclePainter(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.5),
                                          child: Icon(
                                            Icons.circle,
                                            size: 16.0,
                                            color: LightColors.blue,
                                          ),
                                        ),
                                      )
                                    : CustomPaint(
                                        painter: CirclePainter(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.5),
                                          child: Icon(
                                            null,
                                            size: 16.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: GlobalConstants.of(context).spacingSmall,
                              ),
                              child: RichText(
                                text: new TextSpan(
                                  text:
                                      AppLocalizations.of(context)!.iAcceptThe,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    new TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .useTerms,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () => openTermsOfUse(),
                                    ),
                                    new TextSpan(
                                      text: AppLocalizations.of(context)!.and,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    new TextSpan(
                                      text:
                                          AppLocalizations.of(context)!.privacy,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () => openPrivacyPolicy(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            showCheckBoxError
                                ? Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: GlobalConstants.of(
                                          context,
                                        ).spacingNormal,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .youNeedToAcceptTheTermsOfUseToContinue,
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
