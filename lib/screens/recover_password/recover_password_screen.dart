import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';

class RecoverPasswordPage extends StatefulWidget {
  final Map<String, dynamic>? args;

  RecoverPasswordPage([this.args]);

  @override
  _RecoverPasswordPageState createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  late AuthStore authStore;

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool emailIsSent = false;
  bool snackBarActive = false;

  bool mailIsValid = true;

  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _submit() async {
    setState(() {
      snackBarActive = true;
      isLoading = true;
    });

    String lang = "en";
    if (Platform.localeName == "pt_BR") lang = 'ptbr';

    try {
      await authStore.recoverPassword(_emailController.text, lang);
      setState(() {
        isLoading = false;
        snackBarActive = false;
      });

      showModalBottomSheet(
        context: context,
        barrierColor: Colors.black.withAlpha(1),
        backgroundColor: Colors.black.withAlpha(1),
        builder: (BuildContext context) {
          return SnackBarWidget(
            menu: AppLocalizations.of(context)!.checkYourEmail,
            text: AppLocalizations.of(context)!
                .weSentYouALinkToCreateANewPassword,
            emailToConcatenate: _emailController.text,
            about: "",
            onClose: () => onCloseSnackbar(),
          );
        },
      );
    } catch (error) {
      setState(() {
        isLoading = false;
        snackBarActive = false;
      });

      showModalBottomSheet(
        context: context,
        barrierColor: Colors.black.withAlpha(1),
        backgroundColor: Colors.black.withAlpha(1),
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            color: Color(0xff018F9C),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(
                  error.toString() == 'USER_NOT_FOUND'
                      ? AppLocalizations.of(context)!.recoveryMessageError
                      : AppLocalizations.of(context)!
                          .thereWasAProblemPleaseTryAgain,
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                )),
                IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    )),
              ],
            ),
          );
        },
      );
    }
  }

  get appBar => DefaultAppBar(
        components: [
          AppBarComponents.back,
        ],
        onTapLeading: () {
          Navigator.of(context).pop();
        },
      );

  void onCloseSnackbar() {
    setState(() {
      snackBarActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: appBar,
        body: _blocBuilder(),
      ),
    );
  }

  _blocBuilder() {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            color: snackBarActive
                ? Color.fromRGBO(0, 0, 0, 0.3)
                : Color.fromRGBO(0, 0, 0, 0),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: GlobalConstants.of(context).spacingMedium),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: GlobalConstants.of(context).spacingMedium),
                        Text(
                          AppLocalizations.of(context)!.forgotMyPass,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  fontSize: 22, color: LightColors.darkBlue),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: GlobalConstants.of(context).spacingNormal),
                        ),
                        Text(
                            AppLocalizations.of(context)!
                                .recoverPassItsAllRight,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    fontSize: 18, color: LightColors.darkBlue)),
                        Padding(
                          padding: EdgeInsets.only(
                              top: GlobalConstants.of(context).spacingNormal),
                        ),
                        Visibility(
                          visible: !emailIsSent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .recoverPasswordPleaseEnterYourEmailToStartThePasswordRecoveryProcess,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: emailIsSent,
                          child: Icon(
                            Icons.check,
                            size: 120,
                            color: Colors.black,
                          ),
                        ),
                        Visibility(
                          visible: emailIsSent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .sentIfThisIsYourEmailALinkShouldBeInYourInboxSoYouCanUpdateYourPassword,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: !emailIsSent,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: GlobalConstants.of(context).spacingMedium,
                              bottom: GlobalConstants.of(context).spacingLarge,
                            ),
                            child: Column(
                              children: [
                                TextFormField(
                                  onTap: () {
                                    onCloseSnackbar();
                                    mailIsValid = true;
                                    setState(() {});
                                  },
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
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
                                          labelStyle: mailIsValid
                                              ? GoogleFonts.roboto(
                                                  color: LightColors.lightGrey,
                                                  fontWeight: FontWeight.w500)
                                              : GoogleFonts.roboto(
                                                  color: LightColors.errorRed,
                                                  fontWeight: FontWeight.w500),
                                          prefixIcon: ImageIcon(
                                            AssetImage("assets/icons/mail.png"),
                                            color: mailIsValid
                                                ? LightColors.grey
                                                : LightColors.errorRed,
                                          )),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      setState(() {
                                        mailIsValid = false;
                                      });
                                      return AppLocalizations.of(context)!
                                          .pleaseEnterYourValidEmailAddress;
                                    }
                                    if (!value.contains("@") ||
                                        !value.contains(".")) {
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(25, 0, 25, 12),
              child: Visibility(
                visible: !emailIsSent,
                child: Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        child: Padding(
                          padding: EdgeInsets.all(
                            GlobalConstants.of(context).spacingNormal,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.requestNewPassword,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            _submit();
                          }
                        },
                        color: LightColors.blue,
                        splashColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: LightColors.blue,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
