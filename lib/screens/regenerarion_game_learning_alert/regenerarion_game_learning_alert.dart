import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegenerarionGameLearningAlert extends StatefulWidget {
  Map<String, dynamic> args;

  RegenerarionGameLearningAlert(this.args, {Key? key}) : super(key: key);

  @override
  _RegenerarionGameLearningAlertState createState() =>
      _RegenerarionGameLearningAlertState();
}

class _RegenerarionGameLearningAlertState
    extends State<RegenerarionGameLearningAlert> {
  String? _imagePath;
  Color? _backgroundColorIcon;
  IconData? _icon;
  String? _title;
  String? _firstText;
  String? _secondText;
  String? _imageRights;

  @override
  void initState() {
    switch (widget.args["type"]) {
      case "personal":
        _imagePath = "assets/images/personal_background.png";
        _backgroundColorIcon = Color(0xff00A5FC);
        _icon = FeatherIcons.user;
        _title = AppLocalizations.of(widget.args["context"])!.personalLevel;
        _firstText =
            AppLocalizations.of(widget.args["context"])!.personalLevelText1;
        _secondText =
            AppLocalizations.of(widget.args["context"])!.personalLevelText2;
        _imageRights = "Picture by Jan Huber";
        break;

      case "city":
        _imagePath = "assets/images/city_background.png";
        _backgroundColorIcon = Color(0xff0072C5);
        _icon = FeatherIcons.mapPin;
        _title = AppLocalizations.of(widget.args["context"])!.cityLevel;
        _firstText =
            AppLocalizations.of(widget.args["context"])!.cityLevelText1;
        _secondText =
            AppLocalizations.of(widget.args["context"])!.cityLevelText2;
        _imageRights = "Picture by Shane Rounce";

        break;

      case "global":
        _imagePath = "assets/images/planetary_background.png";
        _backgroundColorIcon = Color(0xff012588);
        _icon = FeatherIcons.globe;
        _title = AppLocalizations.of(widget.args["context"])!.planetaryLevel;
        _firstText =
            AppLocalizations.of(widget.args["context"])!.planetaryLevelText1;
        _secondText =
            AppLocalizations.of(widget.args["context"])!.planetaryLevelText2;
        _imageRights = "Picture by Margot Richard";

        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_imagePath as String),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // SvgPicture.asset(
          //   _imagePath as String,
          //   fit: BoxFit.cover,
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          // ),
          Positioned(
            top: MediaQuery.of(context).size.height * .11,
            right: -GlobalConstants.of(context).screenHorizontalSpace - 16,
            child: Transform.rotate(
                angle: 3 * pi / 2,
                child: Container(
                  child: Text(
                    _imageRights as String,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                  ),
                )),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      GlobalConstants.of(context).screenHorizontalSpace),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .regenerationGame
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: Colors.white),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: _backgroundColorIcon,
                        borderRadius: BorderRadius.circular(100)),
                    padding: EdgeInsets.all(24),
                    child: Icon(_icon, size: 130, color: Colors.white),
                  ),
                  Text(_title!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(fontSize: 40, color: Colors.white)),
                  Text(_firstText!,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(fontSize: 18, color: Colors.white)),
                  Text(_secondText!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w500)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 32)),
                              alignment: Alignment.center,
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
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
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      SizedBox(
                        width: 28,
                      ),
                      Expanded(
                        flex: 3,
                        child: TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 32)),
                              alignment: Alignment.center,
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFF003694)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
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
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}