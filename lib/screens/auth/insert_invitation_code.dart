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
  bool exibleText = false;
  bool isLoading = false;
  FocusNode focus = FocusNode();
  RegisterSecondPhaseController registerController =
      RegisterSecondPhaseController.getInstance();
  var insertInvitationCodeStore = InsertInvitationCodeStore();
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();

  SmartPageController pageController = SmartPageController.getInstance();

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
    super.dispose();
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
            physics: isKeyboardOpen ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
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
                        Text(
                          AppLocalizations.of(context)!.invitationCodeWelcome,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        SizedBox(
                          height:
                              GlobalConstants.of(context).screenHorizontalSpace,
                        ),
                        Center(
                            child: Image.asset(
                          'assets/icons/invitation_code_icon.png',
                          height: 166,
                        )),
                        SizedBox(height: 35),
                        Text(
                          AppLocalizations.of(context)!.yourAccessChannel,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 35),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context)!
                                .enterYourInvitationCode,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          height: GlobalConstants.of(context).spacingSmall,
                        ),
                        TextFormField(
                          autocorrect: false,
                          autofocus: false,
                          controller: registerController.codeController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.30),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: exibleText
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
                            enabledBorder: exibleText
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
                            hintText:
                                AppLocalizations.of(context)!.invitationCode,
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          style: exibleText
                              ? GoogleFonts.roboto(
                                  color: Color(0xff8E1816),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16)
                              : GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                          onChanged: (value) async {
                            var statusCode = await insertInvitationCodeStore
                                .verifyCodes(value);

                            setState(() {
                              if (statusCode == 'valid') {
                                visibleValidStatusCode = true;
                                exibleText = false;
                              } else {
                                visibleValidStatusCode = false;
                                exibleText = true;
                              }
                            });
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Visibility(
                          visible: exibleText,
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
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 26.0),
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    style: ButtonStyle(
                                      fixedSize:
                                          MaterialStateProperty.all<Size>(
                                              Size(88, 53)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            side: BorderSide.none),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              EdgeInsets.all(15)),
                                    ),
                                    onPressed: () => goToRegisterPhase(),
                                    child: Text(
                                      AppLocalizations.of(context)!.skip,
                                      style: TextStyle(
                                        color: Color(0xff666666),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                ElevatedButton(
                                    style: ButtonStyle(
                                      fixedSize:
                                          MaterialStateProperty.all<Size>(
                                              Size(212, 53)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            side: BorderSide.none),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        !visibleValidStatusCode
                                            ? Color(0xff5d7fbb)
                                            : Color(0xff003694),
                                      ),
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              EdgeInsets.all(15)),
                                    ),
                                    onPressed: !visibleValidStatusCode
                                        ? null
                                        : () => goToRegisterPhase(),
                                    child: Text(
                                      AppLocalizations.of(context)!.access,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: !visibleValidStatusCode
                                              ? Color(0xffb8c6e1)
                                              : Colors.white),
                                    )),
                              ],
                            ),
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
                            style: TextStyle(color: Colors.white, fontSize: 10),
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
