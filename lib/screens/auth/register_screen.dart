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

  goToPageView() async {
    if (controller.page == 0.0) {
      await controller.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    } else {
      await controller.previousPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    }
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
                                                      () => goToPageView(),
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
                TermsWidget(
                  onTapCheck: updateTermsCheck,
                  confirmTerms: goToPageView,
                  backToPage: backButtonPage,
                  termsCheckbox: _termsCheckbox,
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

class TermsWidget extends StatelessWidget {
  VoidCallback onTapCheck;
  VoidCallback confirmTerms;
  VoidCallback backToPage;
  bool termsCheckbox;
  TermsWidget({
    Key? key,
    required this.onTapCheck,
    required this.confirmTerms,
    required this.backToPage,
    required this.termsCheckbox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Positioned(
                  left: -10,
                  child: BackButton(
                    onPressed: backToPage,
                    color: Colors.black,
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: GlobalConstants.of(context).logoHeight,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextTitleTerms(
                      text: AppLocalizations.of(context)!.termsOfUse),
                  SizedBox(
                    height: 12,
                  ),
                  TextTitleTerms(
                      text: AppLocalizations.of(context)!.termsOfUsePrimary),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text: AppLocalizations.of(context)!.termsOfUseSecond),
                  SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: new TextSpan(
                      children: [
                        new TextSpan(
                          text: AppLocalizations.of(context)!.termsOfUseThird,
                          style: new TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch(
                                  'https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                            },
                        ),
                        new TextSpan(
                          text: AppLocalizations.of(context)!.termsOfUseFourth,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        new TextSpan(
                          text: AppLocalizations.of(context)!.termsOfUseFifth,
                          style: new TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch(
                                  'https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                            },
                        ),
                        new TextSpan(
                          text: AppLocalizations.of(context)!.termsOfUseSixth,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: new TextSpan(
                      children: [
                        new TextSpan(
                          text: AppLocalizations.of(context)!.termsOfUseSeventh,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        new TextSpan(
                          text: AppLocalizations.of(context)!.termsOfUseEighth,
                          style: new TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch(
                                  'https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                            },
                        ),
                        new TextSpan(
                          text: AppLocalizations.of(context)!.termsOfUseNinth,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextTitleTerms(
                    text: AppLocalizations.of(context)!
                        .transparencyAndRespectForYourData,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: new TextSpan(
                      children: [
                        new TextSpan(
                          text: AppLocalizations.of(context)!
                              .transparencyAndRespectForYourDataPrimary,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        new TextSpan(
                          text: AppLocalizations.of(context)!
                              .transparencyAndRespectForYourDataSecond,
                          style: new TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch(
                                  'https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                            },
                        ),
                        new TextSpan(
                          text: AppLocalizations.of(context)!
                              .transparencyAndRespectForYourDataThird,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        new TextSpan(
                          text: AppLocalizations.of(context)!
                              .transparencyAndRespectForYourDataFourth,
                          style: new TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch(
                                  'https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                            },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextTitleTerms(
                    text: AppLocalizations.of(context)!.impressum,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(text: AppLocalizations.of(context)!.corporateName),
                  TextTerms(text: AppLocalizations.of(context)!.address),
                  TextTerms(text: AppLocalizations.of(context)!.localization),
                  TextTerms(text: AppLocalizations.of(context)!.cnpj),
                  TextTerms(text: AppLocalizations.of(context)!.contact),
                  SizedBox(
                    height: 16,
                  ),
                  TextTitleTerms(
                    text: AppLocalizations.of(context)!.theOOTOPIAService,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text: AppLocalizations.of(context)!
                          .theOOTOPIAServicePrimary),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text: AppLocalizations.of(context)!
                          .theOOTOPIAServiceSecond),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text:
                          AppLocalizations.of(context)!.theOOTOPIAServiceThird),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text: AppLocalizations.of(context)!
                          .theOOTOPIAServiceFourth),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text:
                          AppLocalizations.of(context)!.theOOTOPIAServiceFifth),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text:
                          AppLocalizations.of(context)!.theOOTOPIAServiceSixth),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text: AppLocalizations.of(context)!
                          .theOOTOPIAServiceSeventh),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text: AppLocalizations.of(context)!
                          .theOOTOPIAServiceEighth),
                  SizedBox(
                    height: 16,
                  ),
                  TextTitleTerms(
                      text: AppLocalizations.of(context)!.yourCommitments),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text:
                          AppLocalizations.of(context)!.yourCommitmentsPrimary),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text:
                          AppLocalizations.of(context)!.yourCommitmentsSecond),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text: AppLocalizations.of(context)!.yourCommitmentsThird),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text:
                          AppLocalizations.of(context)!.yourCommitmentsFourth),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text: AppLocalizations.of(context)!.yourCommitmentsFifth),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text: AppLocalizations.of(context)!.yourCommitmentsSixth),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text:
                          AppLocalizations.of(context)!.yourCommitmentsSeventh),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text:
                          AppLocalizations.of(context)!.yourCommitmentsEighth),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text: AppLocalizations.of(context)!.yourCommitmentsNinth),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text: AppLocalizations.of(context)!.yourCommitmentsTenth),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text: AppLocalizations.of(context)!
                          .yourCommitmentsEleventh),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text:
                          AppLocalizations.of(context)!.yourCommitmentsTwelfth),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text: AppLocalizations.of(context)!
                          .yourCommitmentsThirteenth),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text: AppLocalizations.of(context)!
                          .yourCommitmentsFourteenth),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text: AppLocalizations.of(context)!
                          .yourCommitmentsFifteenth),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text: AppLocalizations.of(context)!
                          .yourCommitmentsSixteenth),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text: AppLocalizations.of(context)!
                          .yourCommitmentsSeventeenth),
                  SizedBox(
                    height: 16,
                  ),
                  TextTerms(
                      text: AppLocalizations.of(context)!
                          .yourCommitmentsEighteenth),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: onTapCheck,
                      child: Container(
                        child: termsCheckbox
                            ? CustomPaint(
                                painter: CirclePainter(),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Icon(
                                    Icons.check,
                                    size: 14.0,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : CustomPaint(
                                painter: CirclePainter(),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Icon(
                                    null,
                                    size: 14.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      "I accept the use terms",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      child: ElevatedButton(
                        child: Padding(
                          padding: EdgeInsets.all(
                            GlobalConstants.of(context).spacingNormal,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.confirm,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        onPressed: termsCheckbox ? confirmTerms : null,
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(color: Colors.red),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              termsCheckbox ? Colors.white : Colors.white70),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TextTitleTerms extends StatelessWidget {
  final String text;
  const TextTitleTerms({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          this.text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class TextTerms extends StatelessWidget {
  final String text;
  const TextTerms({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    );
  }
}
