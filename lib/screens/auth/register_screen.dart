import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/home/components/page_view_controller.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ootopia_app/bloc/auth/auth_bloc.dart';
import 'package:ootopia_app/data/utils/circle-painter.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

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
        child: WillPopScope(
          onWillPop: () => backButtonPage(),
          child: Scaffold(
            body: _blocBuilder(),
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
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: GlobalConstants.of(context).spacingMedium,
          ),
          child: Form(
            key: _formKey,
            child: PageView(
              scrollDirection: Axis.vertical,
              controller: controller,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
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
                                  Container(
                                    height: 40,
                                    width: 40,
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/butterfly.png"),
                                    ),
                                  )
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
                                      autocorrect: false,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      decoration: GlobalConstants.of(context)
                                          .loginInputTheme(
                                              AppLocalizations.of(context)!
                                                  .nameAndSurname)
                                          .copyWith(
                                              prefixIcon: Icon(
                                            Icons.person_outline,
                                            color: Color(0xFF707070),
                                          )),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return AppLocalizations.of(context)!
                                              .pleaseEnterYourNameAndSurname;
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
                                      decoration: GlobalConstants.of(context)
                                          .loginInputTheme(
                                              AppLocalizations.of(context)!
                                                  .email)
                                          .copyWith(
                                              prefixIcon: Icon(
                                            Icons.mail_outline,
                                            color: Color(0xFF707070),
                                          )),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return AppLocalizations.of(context)!
                                              .pleaseEnterYourEmail;
                                        } else if (!EmailValidator.validate(
                                            value)) {
                                          return AppLocalizations.of(context)!
                                              .pleaseEnterAValidEmail;
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
                                      obscureText: !_showPassword,
                                      decoration: GlobalConstants.of(context)
                                          .loginInputTheme(
                                            AppLocalizations.of(context)!
                                                .password,
                                          )
                                          .copyWith(
                                            prefixIcon: Icon(
                                              Icons.lock_outline,
                                              color: Color(0xFF707070),
                                            ),
                                            suffixIcon: GestureDetector(
                                              child: Icon(
                                                _showPassword == false
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Colors.black,
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
                                          return AppLocalizations.of(context)!
                                              .pleaseEnterYourPassword;
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
                                          .loginInputTheme(
                                            AppLocalizations.of(context)!
                                                .repeatPassword,
                                          )
                                          .copyWith(
                                            prefixIcon: Icon(
                                              Icons.lock_outline,
                                              color: Color(0xFF707070),
                                            ),
                                            suffixIcon: GestureDetector(
                                              child: Icon(
                                                _showRepeatPassword == false
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Colors.black,
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
                                          return AppLocalizations.of(context)!
                                              .pleaseRepeatYourPassword;
                                        }
                                        if (value != _passwordController.text) {
                                          return AppLocalizations.of(context)!
                                              .passwordDoesNotMatch;
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
                                      child: RichText(
                                        text: new TextSpan(
                                          text: AppLocalizations.of(context)!
                                                  .weRespectAndProtectYourPersonalData +
                                              " ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          children: [
                                            new TextSpan(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .checkHere,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                decoration:
                                                    TextDecoration.underline,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              recognizer:
                                                  new TapGestureRecognizer()
                                                    ..onTap = () {
                                                      launch(
                                                          'https://www.ootopia.org/pledge');
                                                    },
                                            ),
                                            new TextSpan(
                                              text: ' ' +
                                                  AppLocalizations.of(context)!
                                                      .ourPledgeForTransparencyAndHighEthicalStandards,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
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
                                                    const EdgeInsets.all(3.0),
                                                child: Icon(
                                                  Icons.check,
                                                  size: 14.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )
                                          : CustomPaint(
                                              painter: CirclePainter(),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Icon(
                                                  null,
                                                  size: 14.0,
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
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          new TextSpan(
                                            text: AppLocalizations.of(context)!
                                                .useTerms,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            recognizer:
                                                new TapGestureRecognizer()
                                                  ..onTap =
                                                      () => openTermsOfUse(),
                                          )
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
                                  AppLocalizations.of(context)!.continueAccess,
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
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
