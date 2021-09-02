import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:ootopia_app/bloc/auth/auth_bloc.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/theme/light/colors.dart';

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

  bool passIsValid = true;
  bool pass2IsValid = true;

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
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
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
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .liveInOotopiaNowMessage,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              color: LightColors.blue,
                                              fontSize: 24),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          child: Image(
                                            image: AssetImage(
                                                "assets/images/butterfly.png"),
                                          ),
                                        ),
                                        Container(
                                          height: 22,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .creatingANewPassword,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              color: LightColors.darkBlue,
                                              fontSize: 22),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height:
                                    GlobalConstants.of(context).spacingSmall,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .creatingANewAccountPassword,
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top:
                                      GlobalConstants.of(context).spacingMedium,
                                  bottom:
                                      GlobalConstants.of(context).spacingLarge,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 72,
                                      child: TextFormField(
                                        controller: _passwordController,
                                        obscureText: !_showPassword,
                                        decoration: GlobalConstants.of(context)
                                            .loginInputTheme(
                                                AppLocalizations.of(context)!
                                                    .password)
                                            .copyWith(
                                              prefixIcon: ImageIcon(
                                                AssetImage(
                                                    "assets/icons/lock.png"),
                                                color: passIsValid
                                                    ? LightColors.grey
                                                    : Colors.red,
                                              ),
                                              suffixIcon: GestureDetector(
                                                child: Icon(
                                                  _showPassword == false
                                                      ? FeatherIcons.eyeOff
                                                      : FeatherIcons.eye,
                                                  color: LightColors.grey,
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
                                                .enterNewPassword;
                                          }
                                          setState(() {
                                            passIsValid = true;
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
                                      child: TextFormField(
                                        controller: _repeatPasswordController,
                                        obscureText: !_showRepeatPassword,
                                        decoration: GlobalConstants.of(context)
                                            .loginInputTheme(
                                                AppLocalizations.of(context)!
                                                    .repeatPassword)
                                            .copyWith(
                                              prefixIcon: ImageIcon(
                                                AssetImage(
                                                    "assets/icons/lock.png"),
                                                color: pass2IsValid
                                                    ? LightColors.grey
                                                    : Colors.red,
                                              ),
                                              suffixIcon: GestureDetector(
                                                child: Icon(
                                                  _showRepeatPassword == false
                                                      ? FeatherIcons.eyeOff
                                                      : FeatherIcons.eye,
                                                  color: LightColors.grey,
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
                                                .pleaseEnterYourPassword;
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 12),
                  child: Column(
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
                            AppLocalizations.of(context)!.createNewPassword,
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
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
