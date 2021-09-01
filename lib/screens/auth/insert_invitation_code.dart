import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ootopia_app/bloc/auth/auth_bloc.dart';
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
  bool visibleValidStatusCode = true;

  @override
  Widget build(BuildContext context) {
    var insertInvitationCodeStore =
        Provider.of<InsertInvitationCodeStore>(context);
    var authBloc = BlocProvider.of<AuthBloc>(context);
    String? code;
    void submit() {
      setState(() {
        if (visibleValidStatusCode) {
          authBloc.add(EmptyEvent());
          authBloc.add(RegisterEvent(
            name: widget.args['FULLNAME'],
            email: widget.args['EMAIL'],
            password: widget.args['PASSWORD'],
            invitationCode: code,
          ));
        } else {
          authBloc.add(EmptyEvent());
          authBloc.add(RegisterEvent(
            name: widget.args['FULLNAME'],
            email: widget.args['EMAIL'],
            password: widget.args['PASSWORD'],
          ));
        }
        // if (widget.args['returnToPageWithArgs'] != null) {
        //   Navigator.of(context).pushNamedAndRemoveUntil(
        //     PageRoute.Page.homeScreen.route,
        //     ModalRoute.withName('/'),
        //     arguments: {
        //       "returnToPageWithArgs": widget.args['returnToPageWithArgs']
        //     },
        //   );
        // } else {
        //   Navigator.of(context).pushNamedAndRemoveUntil(
        //     PageRoute.Page.homeScreen.route,
        //     ModalRoute.withName('/'),
        //   );
        // }
      });
    }

    print(visibleValidStatusCode);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/background_insert_invitation_code.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: GlobalConstants.of(context).spacingLarge,
                ),
                Text(
                  AppLocalizations.of(context)!.termsOfUsePrimary,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                SizedBox(
                  height: GlobalConstants.of(context).screenHorizontalSpace,
                ),
                Center(
                    child: Image.asset('assets/icons_profile/woow_active.png')),
                SizedBox(
                    height: GlobalConstants.of(context).screenHorizontalSpace),
                Text(
                  AppLocalizations.of(context)!.yourAccessChannel,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: GlobalConstants.of(context).spacingSemiLarge),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.enterYourInvitationCode,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: GlobalConstants.of(context).spacingSmall,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.words,
                  autofocus: true,
                  decoration: GlobalConstants.of(context)
                      .loginInputTheme(
                          AppLocalizations.of(context)!.invitationCode)
                      .copyWith(
                          hoverColor: Colors.white,
                          fillColor: Colors.white,
                          hintText:
                              AppLocalizations.of(context)!.invitationCode,
                          hintStyle: TextStyle(color: Colors.grey)),
                  onChanged: (value) {
                    print(value);
                    Future.delayed(Duration(seconds: 6), () async {
                      var statusCode = await insertInvitationCodeStore
                          .verifyCodes('wLYDvO9SjC');
                      setState(() {
                        if (statusCode == 'invalid') {
                          visibleValidStatusCode = false;
                        } else {
                          code = value;
                          visibleValidStatusCode = true;
                          submit();
                        }
                      });
                      print(visibleValidStatusCode);
                    });
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                Visibility(
                  visible: !visibleValidStatusCode,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.enterTheValidInvitationCode,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2),
                  alignment: Alignment.center,
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
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide.none),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(15)),
                          ),
                          onPressed: () {
                            authBloc.add(EmptyEvent());
                            authBloc.add(RegisterEvent(
                                name: widget.args['FULLNAME'],
                                email: widget.args['EMAIL'],
                                password: widget.args['PASSWORD']));
                          },
                          child: Text(
                            AppLocalizations.of(context)!.skip,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          )),
                      ElevatedButton(
                          style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all<Size>(Size(212, 53)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide.none),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xff003694)),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(15)),
                          ),
                          onPressed: visibleValidStatusCode ? null : submit,
                          child: Text(
                            AppLocalizations.of(context)!.access,
                            style: TextStyle(fontSize: 16),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
