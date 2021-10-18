import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/auth/register_second_phase/register_second_phase_controller.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ootopia_app/bloc/auth/auth_bloc.dart';
import 'package:ootopia_app/data/utils/circle-painter.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/shared/design_guide/buttons.dart';

class RegisterPage extends StatefulWidget {
  Map<String, dynamic>? args;

  RegisterPage([this.args]);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthBloc? authBloc;
  final _formKey = GlobalKey<FormState>();
  bool _termsCheckbox = false;
  bool termsOpened = false;
  bool isLoading = false;
  bool showCheckBoxError = false;
  bool _showPassword = false;
  bool _showRepeatPassword = false;
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final PageController controller = PageController(initialPage: 0);

  RegisterSecondPhaseController phase2Controller =
      RegisterSecondPhaseController.getInstance();

  bool nameIsValid = true;
  bool mailIsValid = true;
  bool passIsValid = true;
  bool pass2IsValid = true;

  void _toggleTerms() {
    setState(() {
      termsOpened = !termsOpened;
    });
  }

  void _submit() {
    setState(() {
      if (!_termsCheckbox) {
        showCheckBoxError = true;
        return;
      }
      Navigator.of(context).pushNamed(
        PageRoute.Page.insertInvitationCode.route,
        arguments: {
          "returnToPageWithArgs":
              widget.args != null ? widget.args!['returnToPageWithArgs'] : null,
          "EMAIL": _emailController.text,
          "PASSWORD": _passwordController.text,
          "FULLNAME": _nameController.text
        },
      );
      //isLoading = true;
      //   authBloc!.add(EmptyEvent());
      //   authBloc!.add(RegisterEvent(
      //       name: _nameController.text,
      //       email: _emailController.text,
      //       password: _passwordController.text));
    });
  }

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

  backButtonPage() async {
    _termsCheckbox = false;

    await controller.previousPage(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
    this.trackingEvents.trackingSignupStartedSignup();
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
    return Scaffold(
      appBar: appBar,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ErrorState) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: WillPopScope(
            onWillPop: () => backButtonPage(),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _blocBuilder(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  elevation:
                                      MaterialStateProperty.all<double>(0.0),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  minimumSize: MaterialStateProperty.all(
                                    Size(60, 55),
                                  ),
                                  backgroundColor: _termsCheckbox
                                      ? MaterialStateProperty.all(
                                          LightColors.blue)
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
                                    ? () {
                                        if (_formKey.currentState!.validate()) {
                                          phase2Controller
                                              .cleanTextEditingControllers();
                                          _submit();
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
        ),
      ),
    );
  }

  _blocBuilder() {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is LoadedSucessState || state is ErrorState) {
        isLoading = false;
      }
      return LoadingOverlay(
        isLoading: isLoading,
        child: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Form(
              key: _formKey,
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
                            Platform.localeName == "pt_BR"
                                ? Center(
                                    child: Container(
                                    width: 323,
                                    height: 47,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .liveInOotopiaNowMessage,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.roboto(
                                                  color: LightColors.blue,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            height: 37,
                                            child: Image(
                                              image: AssetImage(
                                                  "assets/images/butterfly.png"),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ))
                                : Center(
                                    child: Container(
                                    width: 278,
                                    height: 47,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .liveInOotopiaNowMessage,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.roboto(
                                                  color: LightColors.blue,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            height: 37,
                                            child: Image(
                                              image: AssetImage(
                                                  "assets/images/butterfly.png"),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            Padding(
                              padding: EdgeInsets.only(
                                top: GlobalConstants.of(context).spacingMedium,
                                bottom: 40,
                              ),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _nameController,
                                    onTap: () {
                                      nameIsValid = true;
                                      setState(() {});
                                    },
                                    keyboardType: TextInputType.name,
                                    autocorrect: true,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: GlobalConstants.of(context)
                                        .loginInputTheme(
                                            AppLocalizations.of(context)!
                                                .nameAndSurname)
                                        .copyWith(
                                          errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                            color: nameIsValid
                                                ? LightColors.grey
                                                : LightColors.errorRed,
                                          )),
                                          errorStyle: nameIsValid
                                              ? TextStyle(
                                                  color: Colors.transparent,
                                                  fontSize: 0)
                                              : TextStyle(),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                  borderSide: BorderSide(
                                            color: nameIsValid
                                                ? LightColors.grey
                                                : LightColors.errorRed,
                                          )),
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
                                      if (value == null || value.isEmpty) {
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
                                    height: GlobalConstants.of(context)
                                        .intermediateSpacing,
                                  ),
                                  TextFormField(
                                    controller: _emailController,
                                    onTap: () {
                                      mailIsValid = true;
                                      setState(() {});
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: GlobalConstants.of(context)
                                        .loginInputTheme(
                                            AppLocalizations.of(context)!.email)
                                        .copyWith(
                                            errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                              color: mailIsValid
                                                  ? LightColors.grey
                                                  : LightColors.errorRed,
                                            )),
                                            errorStyle: mailIsValid
                                                ? TextStyle(
                                                    color: Colors.transparent,
                                                    fontSize: 0)
                                                : TextStyle(),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                                    borderSide: BorderSide(
                                              color: mailIsValid
                                                  ? LightColors.grey
                                                  : LightColors.errorRed,
                                            )),
                                            labelStyle: GoogleFonts.roboto(
                                                color: mailIsValid
                                                    ? LightColors.lightGrey
                                                    : LightColors.errorRed,
                                                fontWeight: FontWeight.w500),
                                            prefixIcon: ImageIcon(
                                              AssetImage(
                                                  "assets/icons/mail.png"),
                                              color: mailIsValid
                                                  ? LightColors.grey
                                                  : LightColors.errorRed,
                                              size: 20,
                                            )),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        setState(() {
                                          mailIsValid = false;
                                        });
                                        return AppLocalizations.of(context)!
                                            .pleaseEnterYourValidEmailAddress;
                                      } else if (!EmailValidator.validate(
                                          value)) {
                                        setState(() {
                                          mailIsValid = false;
                                        });
                                        return AppLocalizations.of(context)!
                                            .pleaseEnterYourValidEmailAddress;
                                      }
                                      setState(() {
                                        mailIsValid = true;
                                      });
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: GlobalConstants.of(context)
                                        .intermediateSpacing,
                                  ),
                                  TextFormField(
                                    controller: _passwordController,
                                    onTap: () {
                                      passIsValid = true;
                                      setState(() {});
                                    },
                                    obscureText: !_showPassword,
                                    decoration: GlobalConstants.of(context)
                                        .loginInputTheme(
                                          AppLocalizations.of(context)!
                                              .password,
                                        )
                                        .copyWith(
                                          errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                            color: passIsValid
                                                ? LightColors.grey
                                                : LightColors.errorRed,
                                          )),
                                          errorStyle: passIsValid
                                              ? TextStyle(
                                                  color: Colors.transparent,
                                                  fontSize: 0)
                                              : TextStyle(),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                  borderSide: BorderSide(
                                            color: passIsValid
                                                ? LightColors.grey
                                                : LightColors.errorRed,
                                          )),
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
                                    height: GlobalConstants.of(context)
                                        .intermediateSpacing,
                                  ),
                                  TextFormField(
                                    controller: _repeatPasswordController,
                                    onTap: () {
                                      pass2IsValid = true;
                                      setState(() {});
                                    },
                                    obscureText: !_showRepeatPassword,
                                    decoration: GlobalConstants.of(context)
                                        .loginInputTheme(
                                          AppLocalizations.of(context)!
                                              .confirmPassword,
                                        )
                                        .copyWith(
                                          errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                            color: pass2IsValid
                                                ? LightColors.grey
                                                : LightColors.errorRed,
                                          )),
                                          errorStyle: pass2IsValid
                                              ? TextStyle(
                                                  color: Colors.transparent,
                                                  fontSize: 0)
                                              : TextStyle(),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                  borderSide: BorderSide(
                                            color: pass2IsValid
                                                ? LightColors.grey
                                                : LightColors.errorRed,
                                          )),
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
                                      if (value == null || value.isEmpty) {
                                        setState(() {
                                          pass2IsValid = false;
                                        });
                                        return AppLocalizations.of(context)!
                                            .pleaseEnterTheSamePassword;
                                      }
                                      if (value != _passwordController.text) {
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
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 2, color: Colors.black)),
                                    child: _termsCheckbox
                                        ? CustomPaint(
                                            painter: CirclePainter(),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(1.5),
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
                                              padding:
                                                  const EdgeInsets.all(1.5),
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
                                    left: GlobalConstants.of(context)
                                        .spacingSmall,
                                  ),
                                  child: RichText(
                                    text: new TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .iAcceptThe,
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
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          recognizer: new TapGestureRecognizer()
                                            ..onTap = () => openTermsOfUse(),
                                        ),
                                        new TextSpan(
                                          text:
                                              AppLocalizations.of(context)!.and,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        new TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .privacy,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
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
        ),
      );
    });
  }
}
