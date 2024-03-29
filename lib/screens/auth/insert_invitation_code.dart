import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/auth/insert_invitation_code_store.dart';
import 'package:ootopia_app/screens/auth/register_controller/register_controller.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:smart_page_navigation/smart_page_navigation.dart';

class InsertInvitationCode extends StatefulWidget {
  final Map<String, dynamic>? args;

  InsertInvitationCode([this.args]);

  @override
  _InsertInvitationCodeState createState() => _InsertInvitationCodeState();
}

class _InsertInvitationCodeState extends State<InsertInvitationCode> {
  bool visibleValidStatusCode = false;
  bool showValidationErrorText = false;
  bool isLoading = false;
  FocusNode focus = FocusNode();
  RegisterSecondPhaseController registerController =
      RegisterSecondPhaseController.getInstance();
  var insertInvitationCodeStore = InsertInvitationCodeStore();
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();

  SmartPageController pageController = SmartPageController.getInstance();
  bool trackingIsActive = true;
  Timer? _debounce;

  void setStatusBar(bool getOutScreen) {
    if (getOutScreen) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle());
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ));
    }
  }

  goToRegisterPhase() {
    Navigator.of(context).pushNamed(
      PageRoute.Page.registerFormScreen.route,
    );
  }

  @override
  void initState() {
    super.initState();
    super.initState();
    registerController.user = User();
    registerController.authStore = AuthStore();
    registerController.cleanTextEditingControllers();

    if (widget.args?['returnToPageWithArgs'] != null &&
        widget.args!['returnToPageWithArgs']['currentPageName'] != null) {
      registerController.returnToPage =
          widget.args!['returnToPageWithArgs']['currentPageName'];
    }

    this.trackingEvents.trackingSignupStartedSignup();
    Future.delayed(Duration(milliseconds: 350), () {
      this.setStatusBar(false);
    });
  }

  @override
  void dispose() {
    this.setStatusBar(true);
    _debounce?.cancel();
    super.dispose();
  }

  void onInsertInvitationCode() async {
    if (registerController.codeController.text.isEmpty) {
      setState(() {
        visibleValidStatusCode = false;
        showValidationErrorText = false;
      });
    } else if (registerController.codeController.text.length < 4 ||
        !(int.tryParse(registerController.codeController.text) is int)) {
      setState(() {
        visibleValidStatusCode = true;
        showValidationErrorText = true;
      });
    } else {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () async {
        var statusCode = await insertInvitationCodeStore
            .verifyCodes(registerController.codeController.text);
        setState(() {
          if (statusCode == 'valid') {
            visibleValidStatusCode = true;
            showValidationErrorText = false;
            if (trackingIsActive) {
              this.trackingEvents.signupCompletedInvitationCode({
                "inivitationCode": registerController.codeController.text,
              });
              trackingIsActive = false;
            }
          } else if (statusCode != "") {
            visibleValidStatusCode = false;
            showValidationErrorText = true;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      body: LoadingOverlay(
        isLoading: isLoading,
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
              physics: isKeyboardOpen
                  ? AlwaysScrollableScrollPhysics()
                  : NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/flower_degrade.jpg',
                      ),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          right: 26.0,
                          left: 26,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                              height: GlobalConstants.of(context).spacingLarge,
                            ),
                            Center(
                                child: Image.asset(
                              'assets/images/white_logo.png',
                              height: 100,
                            )),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .welcomeToTheRegenerativeWorldInWhich,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            Expanded(child: Container()),
                            Align(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .ifYouHaveAnInvitationCodeTypeHere,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: GlobalConstants.of(context).spacingSmall,
                            ),
                            TextFormField(
                              autocorrect: false,
                              autofocus: false,
                              controller: registerController.codeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.30),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: showValidationErrorText
                                    ? OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff8E1816), width: 1),
                                        borderRadius: BorderRadius.circular(8),
                                      )
                                    : OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.30),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                enabledBorder: showValidationErrorText
                                    ? OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff8E1816), width: 1),
                                        borderRadius: BorderRadius.circular(8),
                                      )
                                    : OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.30),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                hoverColor: Colors.white,
                                fillColor: Colors.white,
                                hintText: AppLocalizations.of(context)!
                                    .invitationCode,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              style: showValidationErrorText
                                  ? GoogleFonts.roboto(
                                      color: Color(0xff8E1816),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)
                                  : GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                              onEditingComplete: () {
                                if (registerController
                                    .codeController.text.isEmpty) {
                                  print('valor vazio2');
                                  setState(() {
                                    visibleValidStatusCode = true;
                                    showValidationErrorText = false;
                                  });
                                }
                              },
                              onChanged: (value) async {
                                onInsertInvitationCode();
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Visibility(
                              visible: showValidationErrorText,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .enterTheValidInvitationCode,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20, top: 48),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                        side: BorderSide.none),
                                  ),
                                  minimumSize: MaterialStateProperty.all(
                                    Size(60, 55),
                                  ),
                                  elevation:
                                      MaterialStateProperty.all<double>(0.0),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xff003694)),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.all(
                                              GlobalConstants.of(context)
                                                  .spacingNormal)),
                                ),
                                child: Text(
                                  registerController
                                          .codeController.text.isNotEmpty
                                      ? AppLocalizations.of(context)!
                                          .continueAccess
                                      : AppLocalizations.of(context)!.skip,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  if (registerController
                                          .codeController.text.isNotEmpty &&
                                      visibleValidStatusCode &&
                                      !showValidationErrorText) {
                                    goToRegisterPhase();
                                  }
                                  if (registerController
                                      .codeController.text.isEmpty) {
                                    goToRegisterPhase();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, right: 16),
                          child: RotatedBox(
                            quarterTurns: -1,
                            child: RichText(
                              text: TextSpan(
                                text: AppLocalizations.of(context)!
                                    .pictureByLinaTrochez,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
