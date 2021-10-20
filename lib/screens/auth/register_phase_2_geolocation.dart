import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:ootopia_app/screens/auth/register_second_phase/register_second_phase_controller.dart';
import 'package:ootopia_app/shared/geolocation.dart';
import 'package:ootopia_app/shared/global-constants.dart';

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
  RegisterSecondPhaseController controller =
      RegisterSecondPhaseController.getInstance();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() async {
        await controller.getLocation(context);
      });
    });
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
      body: Container(
        height: double.infinity,
        child: Center(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            GlobalConstants.of(context).screenHorizontalSpace),
                    child: CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .thisIsWhereYourPositiveImpactMattersMost,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Color(0xff707070)),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Image.asset(
                                    'assets/images/earth.png',
                                    width: double.maxFinite,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Container(
                                    child: TextFormField(
                                      enabled: false,
                                      style: TextStyle(color: LightColors.blue, fontWeight: FontWeight.w500),
                                      focusNode: controller.inputFocusNode,
                                      textAlign: TextAlign.left,
                                      controller:
                                          controller.geolocationController,
                                      keyboardType: TextInputType.number,
                                      autofocus: false,
                                      decoration: GlobalConstants.of(context)
                                          .loginInputTheme(
                                              controller.geolocationMessage)
                                          .copyWith(
                                              prefixIcon: Icon(
                                            FeatherIcons.mapPin,
                                            color: controller
                                                        .geolocationController
                                                        .text !=
                                                    null
                                                ? LightColors.blue
                                                : Colors.black,
                                          )),
                                      onEditingComplete: () =>
                                          Geolocation.determinePosition(
                                              context),
                                    ),
                                  ),
                                  Visibility(
                                    visible: controller
                                        .geolocationErrorMessage.isNotEmpty,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: GlobalConstants.of(context)
                                            .spacingNormal,
                                        bottom: GlobalConstants.of(context)
                                            .spacingSmall,
                                      ),
                                      child: Text(
                                        controller.geolocationErrorMessage +
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
                                    height: controller
                                            .geolocationErrorMessage.isNotEmpty
                                        ? GlobalConstants.of(context)
                                            .spacingNormal
                                        : GlobalConstants.of(context)
                                            .spacingLarge,
                                  ),
                                  Visibility(
                                    visible: controller
                                        .geolocationErrorMessage.isNotEmpty,
                                    child: FlatButton(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          GlobalConstants.of(context)
                                              .spacingNormal,
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
                                        setState(() async {
                                          await controller.getLocation(context);
                                        });
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
                                    visible: controller
                                        .geolocationErrorMessage.isNotEmpty,
                                    child: SizedBox(
                                      height: GlobalConstants.of(context)
                                          .spacingNormal,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
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
                                    AppLocalizations.of(context)!
                                        .continueAccess,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      PageRoute
                                          .Page
                                          .registerPhase2TopInterestsScreen
                                          .route,
                                      arguments: widget.args,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
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
