import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/bloc/auth/auth_bloc.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
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
            if (widget.args != null &&
                widget.args!['returnToPageWithArgs'] != null) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                PageRoute.Page.homeScreen.route,
                ModalRoute.withName('/'),
                arguments: {
                  "returnToPageWithArgs": widget.args!['returnToPageWithArgs']
                },
              );
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  PageRoute.Page.homeScreen.route, ModalRoute.withName('/'));
            }
          }
        },
        child: _blocBuilder(),
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
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage("assets/images/login_bg.jpg"),
            //     fit: BoxFit.cover,
            //   ),
            // ),
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
                                  'assets/images/logo.png',
                                  height:
                                      GlobalConstants.of(context).logoHeight,
                                ),
                              ],
                            ),
                            Center(
                              child: Stack(
                                children: [
                                  Container(
                                    width: 225,
                                    height: 45,
                                  ),
                                  Positioned(
                                    bottom: 4,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 25),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .liveInOotopiaNowMessage,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(color: Color(0xFF003694)),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        child: Image(
                                          image: AssetImage(
                                              "assets/images/butterfly.png"),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: GlobalConstants.of(context).spacingMedium,
                              ),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    autofocus: true,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    decoration: GlobalConstants.of(context)
                                        .loginInputTheme(
                                            AppLocalizations.of(context)!.email)
                                        .copyWith(
                                            prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: Colors.grey,
                                        )),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppLocalizations.of(context)!
                                            .pleaseEnterYourEmail;
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: GlobalConstants.of(context)
                                        .spacingMedium,
                                  ),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: !_showPassword,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    decoration: GlobalConstants.of(context)
                                        .loginInputTheme(
                                            AppLocalizations.of(context)!
                                                .password)
                                        .copyWith(
                                          prefixIcon: Icon(Icons.lock),
                                          suffixIcon: GestureDetector(
                                            child: Icon(
                                              _showPassword == false
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.black,
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
                                        return AppLocalizations.of(context)!
                                            .pleaseEnterYourPassword;
                                      }
                                      return null;
                                    },
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 8,
                                bottom:
                                    GlobalConstants.of(context).spacingLarge,
                              ),
                              child: Row(
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
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
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
                            color: Color(0xFF003694),
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
                          SizedBox(
                            height: GlobalConstants.of(context).spacingMedium,
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: GlobalConstants.of(context).spacingMedium,
                          ),
                          Text(
                            AppLocalizations.of(context)!.dontHaveAnAccountYet,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(color: Color(0xFF003694)),
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
                                  color: Color(0xFF003694),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (widget.args != null &&
                                  widget.args!['returnToPageWithArgs'] !=
                                      null) {
                                Navigator.of(context).pushNamed(
                                  PageRoute.Page.registerScreen.route,
                                  arguments: {
                                    "returnToPageWithArgs":
                                        widget.args!['returnToPageWithArgs']
                                  },
                                );
                              } else {
                                Navigator.of(context).pushNamed(
                                    PageRoute.Page.registerScreen.route);
                              }
                            },
                            splashColor: Colors.black54,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color(0xFF003694),
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
