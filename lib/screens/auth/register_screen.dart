import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ootopia_app/bloc/auth/auth_bloc.dart';
import 'package:ootopia_app/screens/timeline/timeline_screen.dart';
import 'package:ootopia_app/shared/global-constants.dart';

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
            print("REGISTERED!!!!!");
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Successfully Registered In"),
              ),
            );
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => TimelinePage(),
                ),
                (Route<dynamic> route) => false);
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
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Create your account and join the \nmovement to heal planet Earth!',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top:
                                      GlobalConstants.of(context).spacingMedium,
                                  bottom:
                                      GlobalConstants.of(context).spacingMedium,
                                ),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _nameController,
                                      keyboardType: TextInputType.name,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        hintText: 'Name and surname',
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter your e-mail';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: GlobalConstants.of(context)
                                          .spacingNormal,
                                    ),
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        hintText: "E-mail",
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter your e-mail';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: GlobalConstants.of(context)
                                          .spacingNormal,
                                    ),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration:
                                          InputDecoration(hintText: "Password"),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter your password';
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
                                      GlobalConstants.of(context).spacingMedium,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'We value and respect your data! That\'s why it will never be trade with third parties. We stand for total transparency and ethics!',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      GlobalConstants.of(context).spacingMedium,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _termsCheckbox,
                                          onChanged: (value) {
                                            setState(() {
                                              _termsCheckbox = !_termsCheckbox;
                                              showCheckBoxError =
                                                  !_termsCheckbox;
                                            });
                                          },
                                        ),
                                        new RichText(
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
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  recognizer:
                                                      new TapGestureRecognizer()
                                                        ..onTap = () =>
                                                            _toggleTerms(),
                                                )
                                              ]),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        showCheckBoxError
                                            ? Flexible(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: GlobalConstants.of(
                                                              context)
                                                          .spacingSmall),
                                                  child: Text(
                                                    "You need to accept the Terms of Use to continue",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.redAccent),
                                                  ),
                                                ),
                                              )
                                            : Container()
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              FlatButton(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    GlobalConstants.of(context).spacingNormal,
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
                                  if (_formKey.currentState.validate()) {
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
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              )
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
    });
  }
}
