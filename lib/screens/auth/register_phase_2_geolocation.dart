import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/auth/register_phase_2_top_interests.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/geolocation.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/theme/light/colors.dart';

class RegisterPhase2GeolocationPage extends StatefulWidget {
  Map<String, dynamic> args;

  RegisterPhase2GeolocationPage(this.args);

  @override
  _RegisterPhase2GeolocationPageState createState() =>
      _RegisterPhase2GeolocationPageState();
}

class _RegisterPhase2GeolocationPageState
    extends State<RegisterPhase2GeolocationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _inputController = TextEditingController();
  FocusNode inputFocusNode = new FocusNode();
  String geolocationErrorMessage = "";
  String geolocationMessage = "Please, wait...";
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _getLocation(context);
    });
    super.initState();
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

  void _getLocation(BuildContext context) {
    setState(() {
      geolocationErrorMessage = "";
      geolocationMessage = AppLocalizations.of(context)!.pleaseWait;
    });
    Geolocation.determinePosition(context).then((Position position) async {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      setState(() {
        if (placemarks.length > 0) {
          var placemark = placemarks[0];
          print("Placemark: ${placemark.toJson()}");
          _inputController.text =
              "${placemark.subAdministrativeArea}, ${placemark.administrativeArea} - ${placemark.country}";

          widget.args['user'].addressCity = placemark.subAdministrativeArea;
          widget.args['user'].addressState = placemark.administrativeArea;
          widget.args['user'].addressCountryCode = placemark.isoCountryCode;
          widget.args['user'].addressLatitude = position.latitude;
          widget.args['user'].addressLongitude = position.longitude;
        } else {
          geolocationMessage =
              AppLocalizations.of(context)!.failedToGetCurrentLocation;
          geolocationErrorMessage =
              AppLocalizations.of(context)!.weCouldntGetYourLocation;
        }
      });
    }).onError((error, stackTrace) {
      setState(() {
        geolocationMessage =
            AppLocalizations.of(context)!.failedToGetCurrentLocation;
        geolocationErrorMessage = error.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(
        height: double.infinity,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/images/login_bg.jpg"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Center(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(
                      GlobalConstants.of(context).spacingMedium,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .thisIsWhereYourPositiveImpactMattersMost,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: LightColors.grey),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: GlobalConstants.of(context).spacingSmall,
                          ),
                        ),
                        Container(
                          height: 351,
                          width: 351,
                          child: Image.asset(
                            'assets/images/earth.png',
                            height: 351,
                            width: 351,
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            enabled: false,
                            style: TextStyle(color: LightColors.blue),
                            focusNode: inputFocusNode,
                            textAlign: TextAlign.center,
                            controller: _inputController,
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            decoration: GlobalConstants.of(context)
                                .loginInputTheme(geolocationMessage)
                                .copyWith(
                                    prefixIcon: Icon(
                                  FeatherIcons.mapPin,
                                  color: _inputController.text != null
                                      ? LightColors.blue
                                      : Colors.black,
                                )),
                            onEditingComplete: () =>
                                Geolocation.determinePosition(context),
                          ),
                        ),
                        Visibility(
                          visible: geolocationErrorMessage.isNotEmpty,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: GlobalConstants.of(context).spacingNormal,
                              bottom: GlobalConstants.of(context).spacingSmall,
                            ),
                            child: Text(
                              geolocationErrorMessage +
                                  AppLocalizations.of(context)!
                                      .tryToRetrieveYourCurrentLocationClickingByGetLocationAgain,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: geolocationErrorMessage.isNotEmpty
                              ? GlobalConstants.of(context).spacingNormal
                              : GlobalConstants.of(context).spacingLarge,
                        ),
                        Visibility(
                          visible: geolocationErrorMessage.isNotEmpty,
                          child: FlatButton(
                            child: Padding(
                              padding: EdgeInsets.all(
                                GlobalConstants.of(context).spacingNormal,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .getCurrentLocation,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onPressed: () {
                              _getLocation(context);
                            },
                            splashColor: Colors.black54,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.white,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: geolocationErrorMessage.isNotEmpty,
                          child: SizedBox(
                            height: GlobalConstants.of(context).spacingNormal,
                          ),
                        ),
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
                            this
                                .trackingEvents
                                .signupCompletedStepIIIOfSignupII({
                              "addressCity": widget.args['user'].addressCity,
                              "addressState": widget.args['user'].addressState,
                              "addressCountryCode":
                                  widget.args['user'].addressCountryCode,
                            });
                            Navigator.of(context).pushNamed(
                              PageRoute
                                  .Page.registerPhase2TopInterestsScreen.route,
                              arguments: widget.args,
                            );
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
