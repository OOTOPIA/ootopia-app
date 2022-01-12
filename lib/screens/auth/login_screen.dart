import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/auth/components/logo.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/shared/snackbar_component.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class LoginPage extends StatefulWidget {
  final Map<String, dynamic>? args;

  const LoginPage([this.args]);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthStore authStore;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _showPassword = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool mailIsValid = true;
  bool passIsValid = true;

  SmartPageController controller = SmartPageController.getInstance();

  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 1000), () {
      if (widget.args != null && widget.args!['returnToPageWithArgs'] != null) {
        if (widget.args!['returnToPageWithArgs']['newPassword'] != null) {
          _passwordController.text =
              widget.args!['returnToPageWithArgs']['newPassword'];
        }
      }
    });
    Future.delayed(Duration.zero, () async {
      if (widget.args != null && widget.args!['returnToPageWithArgs'] != null) {
        if (widget.args!['returnToPageWithArgs']
            ['visibleSnackBarResetPassword']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: Color(0xff018F9C),
              content: Text(AppLocalizations.of(context)!
                  .yourPasswordHasBeenChangedSuccessfully),
            ),
          );
        }
      }
    });
    isLoading = false;
  }

  goToRegister() {
    if (widget.args != null && widget.args!['returnToPageWithArgs'] != null) {
      Navigator.of(context).pushNamed(
        PageRoute.Page.insertInvitationCode.route,
        arguments: {
          'returnToPageWithArgs': {
            'currentPageName': widget.args!['returnToPageWithArgs']
                ['currentPageName']
          }
        },
      );
    } else {
      Navigator.of(context).pushNamed(
        PageRoute.Page.insertInvitationCode.route,
      );
    }
  }

  void _submit() async {
    setState(() {
      isLoading = true;
    });

    try {
      await authStore.login(
          _emailController.text.trim(), _passwordController.text);
      authStore.setUserIsLogged();
      controller.resetNavigation();

      setState(() {
        isLoading = false;
      });

      if (widget.args != null && widget.args!['returnToPageWithArgs'] != null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          PageRoute.Page.homeScreen.route,
          (Route<dynamic> route) => false,
          arguments: {
            "returnToPageWithArgs": widget.args!['returnToPageWithArgs']
          },
        );
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
          PageRoute.Page.homeScreen.route,
          (Route<dynamic> route) => false,
        );
      }
    } catch (error) {
      showModalBottomSheet(
        context: context,
        barrierColor: Colors.black.withAlpha(1),
        backgroundColor: Colors.black.withAlpha(1),
        builder: (BuildContext context) {
          return SnackBarWidget(
            menu: AppLocalizations.of(context)!.errorLogin,
            text: error.toString() == 'INVALID_PASSWORD'
                ? AppLocalizations.of(context)!.invalidEmailOrPassword
                : AppLocalizations.of(context)!.thereWasAProblemPleaseTryAgain,
          );
        },
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: _blocBuilder(),
      ),
    );
  }

  _blocBuilder() {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                      'assets/images/butterfly_top.png',
                    fit: BoxFit.cover,

                  ),
                )),
            Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'assets/images/butterfly_bottom.png',
                    fit: BoxFit.cover,

                  ),
                )),
            Container(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(GlobalConstants.of(context).spacingMedium),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Logo(),
                              Padding(
                                padding: EdgeInsets.only(top: 36),
                                child: Column(
                                  children: [
                                    Container(
                                      child: TextFormField(
                                        controller: _emailController,
                                        autocorrect: false,
                                        enableSuggestions: false,
                                        onTap: () {
                                          mailIsValid = true;
                                          setState(() {});
                                        },
                                        keyboardType: TextInputType.emailAddress,
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                        decoration: GlobalConstants.of(context)
                                            .loginInputTheme(
                                                AppLocalizations.of(context)!.email)
                                            .copyWith(
                                                prefixIcon: ImageIcon(
                                                  AssetImage("assets/icons/mail.png"),
                                                  color: mailIsValid
                                                      ? LightColors.grey
                                                      : LightColors.errorRed,
                                                  size: 20,
                                                ),
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
                                                        fontWeight: FontWeight.w500)),
                                        validator: (value) {
                                          value = value!.trim();
                                          if (value.isEmpty) {
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
                                    ),
                                    SizedBox(
                                      height:
                                          GlobalConstants.of(context).spacingMedium,
                                    ),
                                    Container(
                                      child: Stack(
                                        children: [
                                          TextFormField(
                                            controller: _passwordController,
                                            onTap: () {
                                              passIsValid = true;
                                              setState(() {});
                                            },
                                            obscureText: !_showPassword,
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                            decoration: GlobalConstants.of(context)
                                                .loginInputTheme(
                                                    AppLocalizations.of(context)!
                                                        .password)
                                                .copyWith(
                                                  errorStyle: passIsValid
                                                      ? TextStyle(
                                                          color: Colors.transparent,
                                                          fontSize: 0)
                                                      : TextStyle(),
                                                  labelStyle: passIsValid
                                                      ? GoogleFonts.roboto(
                                                          color:
                                                              LightColors.lightGrey,
                                                          fontWeight: FontWeight.w500)
                                                      : GoogleFonts.roboto(
                                                          color: LightColors.errorRed,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                  prefixIcon: ImageIcon(
                                                    AssetImage(
                                                        "assets/icons/lock.png"),
                                                    color: passIsValid
                                                        ? LightColors.grey
                                                        : LightColors.errorRed,
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                    color: passIsValid
                                                        ? LightColors.grey
                                                        : LightColors.errorRed,
                                                  )),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                    color: passIsValid
                                                        ? LightColors.grey
                                                        : LightColors.errorRed,
                                                  )),
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
                                                        _showPassword =
                                                            !_showPassword;
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
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(PageRoute
                                                .Page.recoverPasswordScreen.route);
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .iForgotMyPassword,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              decoration: TextDecoration.underline,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 24,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FlatButton(
                              child: Padding(
                                padding: EdgeInsets.all(
                                  GlobalConstants.of(context).spacingNormal,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.login,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () {
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
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              height: 1,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 28,
                            ),
                            Text(
                              AppLocalizations.of(context)!.dontHaveAnAccountYet,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(color: LightColors.blue),
                            ),
                            SizedBox(
                              height: GlobalConstants.of(context).spacingNormal,
                            ),
                            FlatButton(
                              child: Padding(
                                padding: EdgeInsets.all(
                                  GlobalConstants.of(context).spacingNormal,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.createAccount,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: LightColors.blue,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                goToRegister();
                              },
                              splashColor: Colors.black54,
                              color: Colors.white.withOpacity(0.6),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: LightColors.blue,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
