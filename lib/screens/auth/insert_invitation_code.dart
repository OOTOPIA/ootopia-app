import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/auth/insert_invitation_code_store.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:provider/provider.dart';

class InsertInvitationCode extends StatefulWidget {
  final Map<String, dynamic> args;
  InsertInvitationCode(this.args);

  @override
  _InsertInvitationCodeState createState() => _InsertInvitationCodeState();
}

class _InsertInvitationCodeState extends State<InsertInvitationCode> {
  bool visibleValidStatusCode = false;
  bool exibleText = false;
  bool isLoading = false;
  TextEditingController _codeController = TextEditingController();
  FocusNode focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    var insertInvitationCodeStore =
        Provider.of<InsertInvitationCodeStore>(context);
    var auth = Provider.of<AuthStore>(context);

    void submit(bool selectAccess) async {
      setState(() {
        isLoading = true;
      });
      try {
        if (selectAccess) {
          var user = await auth.registerUser(
            name: widget.args['FULLNAME'],
            email: widget.args['EMAIL'],
            password: widget.args['PASSWORD'],
            invitationCode: _codeController.text,
            context: context,
          );
          if (user) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              PageRoute.Page.celebration.route,
              ModalRoute.withName('/'),
              arguments: {
                "returnToPageWithArgs": widget.args['returnToPageWithArgs'],
                "name": widget.args['FULLNAME'],
                "goal": "inivitationCode",
                "balance": "15,00",
                "homepage": true
              },
            );
          }
        } else {
          var user = await auth.registerUser(
            name: widget.args['FULLNAME'],
            email: widget.args['EMAIL'],
            password: widget.args['PASSWORD'],
            context: context,
          );
          if (user) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              PageRoute.Page.homeScreen.route,
              ModalRoute.withName('/'),
            );
          }
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        String errorMessage = e.toString();
        switch (errorMessage) {
          case "EMAIL_ALREADY_EXISTS":
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'There is already a registered user with that email address')),
            );
            break;
          case "Invitation Code invalid":
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invitation Code invalid')),
            );
            break;
          default:
        }
      }
    }

    return Scaffold(
      body: LoadingOverlay(
        isLoading: isLoading,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/flower_degrade.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              ListView(
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height:
                                    GlobalConstants.of(context).spacingLarge,
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .invitationCodeWelcome,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                              SizedBox(
                                height: GlobalConstants.of(context)
                                    .screenHorizontalSpace,
                              ),
                              Center(
                                  child: Image.asset(
                                'assets/icons/invitation_code_icon.png',
                                height: 166,
                              )),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, right: 16),
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
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26.0),
                        child: Column(
                          children: [
                            SizedBox(height: 35),
                            Text(
                              AppLocalizations.of(context)!.yourAccessChannel,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 35),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .enterYourInvitationCode,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              height: GlobalConstants.of(context).spacingSmall,
                            ),
                            TextFormField(
                              autocorrect: false,
                              autofocus: false,
                              controller: _codeController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.30),
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
                                hintText: AppLocalizations.of(context)!
                                    .invitationCode,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              style: exibleText
                                  ? TextStyle(
                                      color: Color(0xff8E1816),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16)
                                  : TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
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
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        bottom: 24.0, left: 26, right: 26),
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                              fixedSize:
                                  MaterialStateProperty.all<Size>(Size(88, 53)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side: BorderSide.none),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(15)),
                            ),
                            onPressed: () => submit(false),
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
                              fixedSize: MaterialStateProperty.all<Size>(
                                  Size(212, 53)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side: BorderSide.none),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                !visibleValidStatusCode
                                    ? Color(0xff5d7fbb)
                                    : Color(0xff003694),
                              ),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(15)),
                            ),
                            onPressed: !visibleValidStatusCode
                                ? null
                                : () => submit(true),
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
                  SizedBox(
                    height: 24,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
