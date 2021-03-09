import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/bloc/auth/auth_bloc.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/auth/register_screen.dart';
import 'package:ootopia_app/screens/timeline/timeline_screen.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthBloc authBloc;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
  }

  void _submit() {
    setState(() {
      isLoading = true;
      authBloc.add(EmptyEvent());
      authBloc.add(LoginEvent(_emailController.text, _passwordController.text));
    });
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
            print("LOGGED!!!!!");
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Color(0xff66bb6a),
                content: Text("Successfully Logged In"),
              ),
            );
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => TimelinePage(),
                ),
                (Route<dynamic> route) => false);
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
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
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
                                  'assets/images/white_logo.png',
                                  height:
                                      GlobalConstants.of(context).logoHeight,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: GlobalConstants.of(context)
                                      .spacingNormal),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'If not now, then when?\r\nIf not us, then who?\r\n\r\nWelcome to the movement to \r\nheal planet Earth!',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
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
                                    decoration: GlobalConstants.of(context)
                                        .loginInputTheme("E-mail"),
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
                                    decoration: GlobalConstants.of(context)
                                        .loginInputTheme("Password"),
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
                                top: GlobalConstants.of(context).spacingLarge,
                                bottom:
                                    GlobalConstants.of(context).spacingLarge,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'I forgot my password',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
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
                                "Create account",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ),
                              );
                            },
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
                            height: GlobalConstants.of(context).spacingNormal,
                          ),
                          FlatButton(
                            child: Padding(
                              padding: EdgeInsets.all(
                                GlobalConstants.of(context).spacingNormal,
                              ),
                              child: Text(
                                "Login",
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
