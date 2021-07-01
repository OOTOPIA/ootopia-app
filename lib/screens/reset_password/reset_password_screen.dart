import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/bloc/auth/auth_bloc.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class ResetPasswordPage extends StatefulWidget {
  Map<String, dynamic>? args;

  ResetPasswordPage([this.args]);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late AuthBloc authBloc;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _showPassword = false;
  bool _showRepeatPassword = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
  }

  void _submit() {
    setState(() {
      isLoading = true;
      authBloc.add(EmptyEvent());
      authBloc.add(ResetPasswordEvent(_passwordController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ErrorResetPasswordState) {
            isLoading = false;
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is LoadedSucessResetPasswordState) {
            isLoading = false;
            Navigator.of(context).pushNamedAndRemoveUntil(
              PageRoute.Page.loginScreen.route,
              ModalRoute.withName('/'),
              arguments: {
                "returnToPageWithArgs": {
                  "newPassword": _passwordController.text,
                }
              },
            );
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
                                Flexible(
                                  child: Text(
                                    'Alterar senha',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: GlobalConstants.of(context).spacingMedium,
                                bottom:
                                    GlobalConstants.of(context).spacingLarge,
                              ),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: !_showPassword,
                                    decoration: GlobalConstants.of(context)
                                        .loginInputTheme("Password")
                                        .copyWith(
                                          suffixIcon: GestureDetector(
                                            child: Icon(
                                              _showPassword == false
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.white,
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
                                        return 'Informe a nova senha';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: GlobalConstants.of(context)
                                        .spacingNormal,
                                  ),
                                  TextFormField(
                                    controller: _repeatPasswordController,
                                    obscureText: !_showRepeatPassword,
                                    decoration: GlobalConstants.of(context)
                                        .loginInputTheme('Repeat password')
                                        .copyWith(
                                          suffixIcon: GestureDetector(
                                            child: Icon(
                                              _showRepeatPassword == false
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.white,
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
                                        return 'Por favor, informe sua senha';
                                      }
                                      if (value != _passwordController.text) {
                                        return 'Senhas não combinam';
                                      }
                                      return null;
                                    },
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
                                "Enviar",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
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
