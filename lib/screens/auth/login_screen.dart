import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/bloc/auth/auth_bloc.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class LoginPage extends StatefulWidget {
  Map<String, dynamic>? args;

  LoginPage([this.args]);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthBloc? authBloc;
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
    authBloc = BlocProvider.of<AuthBloc>(context);
    Timer(Duration(milliseconds: 1000), () {
      if (widget.args != null && widget.args!['returnToPageWithArgs'] != null) {
        if (widget.args!['returnToPageWithArgs']['newPassword'] != null) {
          _passwordController.text =
              widget.args!['returnToPageWithArgs']['newPassword'];
        }
      }
    });
  }

  void _submit() {
    setState(() {
      isLoading = true;
      authBloc!.add(EmptyEvent());
      authBloc!
          .add(LoginEvent(_emailController.text, _passwordController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    var authStore = Provider.of<AuthStore>(context);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is ErrorState) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            } else if (state is LoadedSucessState) {
              print("LOGGED!!!!!");
              authStore.setUserIsLogged();
              controller.resetNavigation();
              if (widget.args != null &&
                  widget.args!['returnToPageWithArgs'] != null) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  PageRoute.Page.homeScreen.route,
                  (Route<dynamic> route) => false,
                  arguments: {
                    "returnToPageWithArgs": widget.args!['returnToPageWithArgs']
                  },
                );
              } else {
                // Navigator.of(context).popUntil(
                //     ModalRoute.withName(PageRoute.Page.homeScreen.route));
                Navigator.of(context).pushNamedAndRemoveUntil(
                  PageRoute.Page.homeScreen.route,
                  (Route<dynamic> route) => false,
                );
              }
            }
          },
          child: _blocBuilder(),
        ),
      ),
    );
  }

  _blocBuilder() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is LoadedSucessState) {
          isLoading = false;
        }
        if (state is ErrorState) {
          isLoading = false;
        }
        return LoadingOverlay(
          isLoading: isLoading,
          child: Container(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.all(GlobalConstants.of(context).spacingMedium),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/newlogo.png',
                                  // height:
                                  //     GlobalConstants.of(context).logoHeight,
                                ),
                              ],
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      AppLocalizations.of(context)!
                                          .liveInOotopiaNowMessage,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                          color: LightColors.blue,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900)),
                                  Column(
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        child: Image(
                                          image: AssetImage(
                                              "assets/images/butterfly.png"),
                                        ),
                                      ),
                                      Container(
                                        height: 32,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: GlobalConstants.of(context).spacingMedium,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 72,
                                    child: TextFormField(
                                      autocorrect: false,
                                      enableSuggestions: false,
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      decoration: GlobalConstants.of(context)
                                          .loginInputTheme(
                                              AppLocalizations.of(context)!
                                                  .email)
                                          .copyWith(
                                              prefixIcon: ImageIcon(
                                                AssetImage(
                                                    "assets/icons/mail.png"),
                                                color: mailIsValid
                                                    ? LightColors.grey
                                                    : LightColors.errorRed,
                                                size: 20,
                                              ),
                                              labelStyle: mailIsValid
                                                  ? GoogleFonts.roboto(
                                                      color:
                                                          LightColors.lightGrey,
                                                      fontWeight:
                                                          FontWeight.w500)
                                                  : GoogleFonts.roboto(
                                                      color:
                                                          LightColors.errorRed,
                                                      fontWeight:
                                                          FontWeight.w500)),
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
                                  ),
                                  SizedBox(
                                    height: GlobalConstants.of(context)
                                        .spacingSmall,
                                  ),
                                  Container(
                                      height: 72,
                                      child: Stack(
                                        children: [
                                          TextFormField(
                                            controller: _passwordController,
                                            obscureText: !_showPassword,
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                            decoration: GlobalConstants.of(
                                                    context)
                                                .loginInputTheme(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .password)
                                                .copyWith(
                                                  labelStyle: passIsValid
                                                      ? GoogleFonts.roboto(
                                                          color: LightColors
                                                              .lightGrey,
                                                          fontWeight:
                                                              FontWeight.w500)
                                                      : GoogleFonts.roboto(
                                                          color: LightColors
                                                              .errorRed,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                  prefixIcon: ImageIcon(
                                                    AssetImage(
                                                        "assets/icons/lock.png"),
                                                    color: passIsValid
                                                        ? LightColors.grey
                                                        : LightColors.errorRed,
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
                                                        _showPassword =
                                                            !_showPassword;
                                                      });
                                                    },
                                                  ),
                                                ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                setState(() {
                                                  passIsValid = false;
                                                });
                                                return AppLocalizations.of(
                                                        context)!
                                                    .pleaseEnterYourPassword;
                                              }
                                              setState(() {
                                                passIsValid = true;
                                              });

                                              return null;
                                            },
                                          ),
                                          Positioned(
                                            bottom: -45,
                                            right: 0,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                top: 0,
                                                bottom:
                                                    GlobalConstants.of(context)
                                                        .spacingLarge,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed(PageRoute
                                                              .Page
                                                              .recoverPasswordScreen
                                                              .route);
                                                    },
                                                    child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .iForgotMyPassword,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          color: Colors.black,
                                                        )

                                                        // TextStyle(
                                                        //     fontSize: 12,
                                                        //     fontWeight: FontWeight.bold,
                                                        //     decoration: TextDecoration.underline,
                                                        //     color: Colors.black,
                                                        //     fontFamily: 'RobotoRegular'),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
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
                              Navigator.of(context).pushNamed(
                                  PageRoute.Page.registerScreen.route);
                            },
                            splashColor: Colors.black54,
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
        );
      },
    );
  }
}
