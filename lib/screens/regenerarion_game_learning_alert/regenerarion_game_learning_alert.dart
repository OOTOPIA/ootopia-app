import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegenerarionGameLearningAlert extends StatelessWidget {
  Map<String, dynamic> args;

  RegenerarionGameLearningAlert(this.args, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://images.unsplash.com/photo-1568214697537-ace27ffd6cf3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: GlobalConstants.of(context).screenHorizontalSpace),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "REGENERATION GAME",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.white),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xff00A5FC),
                      borderRadius: BorderRadius.circular(100)),
                  padding: EdgeInsets.all(40),
                  child:
                      Icon(FeatherIcons.mapPin, size: 86, color: Colors.white),
                ),
                Text("Personal level",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontSize: 40, color: Colors.white)),
                Text(
                    "Every person and every action counts! In the regen game you receive credits in OOz currency as a reward for your engagement in the with the app.",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontSize: 18, color: Colors.white)),
                Text("Set your daily goal and start living OOTOPIA now!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 32)),
                          alignment: Alignment.center,
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ))),
                      child: Text(
                        AppLocalizations.of(context)!.close,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => {},
                    ),
                    SizedBox(
                      width: 28,
                    ),
                    TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 32)),
                          alignment: Alignment.center,
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFF003694)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ))),
                      child: Text(
                        AppLocalizations.of(context)!.learnMore,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => {},
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
