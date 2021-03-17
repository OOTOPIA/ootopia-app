import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ootopia_app/bloc/auth/auth_bloc.dart';
import 'package:ootopia_app/data/utils/circle-painter.dart';
import 'package:ootopia_app/screens/timeline/timeline_screen.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:email_validator/email_validator.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthBloc authBloc;
  final _formKey = GlobalKey<FormState>();
  bool _termsCheckbox = false;
  bool termsOpened = false;
  bool isLoading = false;
  bool showCheckBoxError = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

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
      isLoading = true;
      authBloc.add(EmptyEvent());
      authBloc.add(RegisterEvent(_nameController.text, _emailController.text,
          _passwordController.text));
    });
  }

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
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
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              builder: (context) {
                return TimelinePage();
              },
            ), (Route<dynamic> route) => false);
          }
        },
        child: Scaffold(
          body: _blocBuilder(),
        ),
      ),
    );
  }

  _blocBuilder() {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is LoadedSucessState || state is ErrorState) {
        isLoading = false;
      }
      return ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/login_bg.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(
                      GlobalConstants.of(context).spacingMedium,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/white_logo.png',
                                    height:
                                        GlobalConstants.of(context).logoHeight,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top:
                                      GlobalConstants.of(context).spacingNormal,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Visibility(
                                      visible: !termsOpened,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Create your account and join the \nmovement to heal planet Earth!',
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: GlobalConstants.of(context)
                                                  .spacingMedium,
                                              bottom:
                                                  GlobalConstants.of(context)
                                                      .spacingMedium,
                                            ),
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  controller: _nameController,
                                                  keyboardType:
                                                      TextInputType.name,
                                                  autofocus: true,
                                                  decoration: GlobalConstants
                                                          .of(context)
                                                      .loginInputTheme(
                                                          'Name and surname'),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please enter your name and surname';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(
                                                  height: GlobalConstants.of(
                                                          context)
                                                      .spacingNormal,
                                                ),
                                                TextFormField(
                                                  controller: _emailController,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  decoration:
                                                      GlobalConstants.of(
                                                              context)
                                                          .loginInputTheme(
                                                              'E-mail'),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please enter your e-mail';
                                                    } else if (!EmailValidator
                                                        .validate(value)) {
                                                      return 'Please enter a valid e-mail';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(
                                                  height: GlobalConstants.of(
                                                          context)
                                                      .spacingNormal,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      _passwordController,
                                                  obscureText: true,
                                                  decoration:
                                                      GlobalConstants.of(
                                                              context)
                                                          .loginInputTheme(
                                                              'Password'),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please enter your password';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(
                                                  height: GlobalConstants.of(
                                                          context)
                                                      .spacingNormal,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      _repeatPasswordController,
                                                  obscureText: true,
                                                  decoration: GlobalConstants
                                                          .of(context)
                                                      .loginInputTheme(
                                                          'Repeat password'),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please repeat your password';
                                                    }
                                                    if (value !=
                                                        _passwordController
                                                            .text) {
                                                      return 'Password does not match';
                                                    }
                                                    return null;
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              bottom:
                                                  GlobalConstants.of(context)
                                                      .spacingMedium,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    'We value and respect your data! That\'s why it will never be trade with third parties. We stand for total transparency and ethics!',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Visibility(
                                      visible: termsOpened,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: GlobalConstants.of(context)
                                                .spacingMedium),
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              300,
                                          child: SafeArea(
                                            child: Scrollbar(
                                              child: SingleChildScrollView(
                                                child: Flexible(
                                                  child: Text(
                                                    "01. This is a term\n\nLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.\n\n02. This is a term\n\nLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.\n\n03. This is a term\n\nLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.\n\n04. This is a term\n\nLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Visibility(
                                      visible: termsOpened,
                                      child: IconButton(
                                        icon: Image.asset(
                                            'assets/icons/close.png'),
                                        color: Colors.white,
                                        onPressed: () {
                                          _toggleTerms();
                                        },
                                      ),
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
                                      bottom: GlobalConstants.of(context)
                                          .spacingMedium,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  setState(() {
                                                    _termsCheckbox =
                                                        !_termsCheckbox;
                                                  });
                                                });
                                              },
                                              child: Container(
                                                child: _termsCheckbox
                                                    ? CustomPaint(
                                                        painter:
                                                            CirclePainter(),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: Icon(
                                                            Icons.check,
                                                            size: 14.0,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )
                                                    : CustomPaint(
                                                        painter:
                                                            CirclePainter(),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: Icon(
                                                            null,
                                                            size: 14.0,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left:
                                                    GlobalConstants.of(context)
                                                        .spacingSmall,
                                              ),
                                              child: RichText(
                                                text: new TextSpan(
                                                    text: 'I accept the ',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                    children: [
                                                      new TextSpan(
                                                        text: 'use terms.',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        recognizer:
                                                            new TapGestureRecognizer()
                                                              ..onTap = () =>
                                                                  _toggleTerms(),
                                                      )
                                                    ]),
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
                                                        "You need to accept the Terms of Use to continue",
                                                        style: TextStyle(
                                                          color:
                                                              Colors.redAccent,
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      FlatButton(
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                            GlobalConstants.of(context)
                                                .spacingNormal,
                                          ),
                                          child: Text(
                                            "Create account",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _submit();
                                          }
                                        },
                                        color: Colors.white,
                                        splashColor: Colors.black54,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.white,
                                            width: 2,
                                            style: BorderStyle.solid,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
