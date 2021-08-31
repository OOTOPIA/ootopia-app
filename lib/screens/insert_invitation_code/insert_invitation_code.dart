import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/global-constants.dart';

class InsertInvitationCode extends StatefulWidget {
  const InsertInvitationCode({Key? key}) : super(key: key);

  @override
  _InsertInvitationCodeState createState() => _InsertInvitationCodeState();
}

class _InsertInvitationCodeState extends State<InsertInvitationCode> {
  TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                      child:
                          Image.asset('assets/icons_profile/woow_active.png')),
                  SizedBox(
                      height:
                          GlobalConstants.of(context).screenHorizontalSpace),
                  Text(
                    AppLocalizations.of(context)!.yourAccessChannel,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                      height: GlobalConstants.of(context).spacingSemiLarge),
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
                    controller: _codeController,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .pleaseEnterYourNameAndSurname;
                      }
                      return null;
                    },
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide.none),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(15)),
                            ),
                            onPressed: () {},
                            child: Text(
                              AppLocalizations.of(context)!.skip,
                              style: TextStyle(color: Colors.black),
                            )),
                        ElevatedButton(
                            style: ButtonStyle(
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
                            onPressed: () {},
                            child: Text(AppLocalizations.of(context)!.access))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
