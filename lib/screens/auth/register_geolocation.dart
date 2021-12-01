import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/data/models/general_config/general_config_model.dart';
import 'package:ootopia_app/screens/auth/register_controller/register_controller.dart';

import 'package:ootopia_app/shared/geolocation.dart';
import 'package:ootopia_app/shared/global-constants.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class RegisterGeolocationScreen extends StatefulWidget {
  final Map<String, dynamic>? args;

  const RegisterGeolocationScreen([this.args]);

  @override
  _RegisterGeolocationScreenState createState() =>
      _RegisterGeolocationScreenState();
}

class _RegisterGeolocationScreenState extends State<RegisterGeolocationScreen> {
  RegisterSecondPhaseController registerController =
      RegisterSecondPhaseController.getInstance();
  bool isLoading = false;
  bool isLoadingLocation = true;
  SecureStoreMixin secureStoreMixin = SecureStoreMixin();
  SmartPageController navigationController = SmartPageController.getInstance();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await registerController.getLocation(context);
      isLoadingLocation = false;
      setState(() {});
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

  Future _register() async {
    try {
      setState(() {
        isLoading = true;
      });
      await registerController.registerUser();

      setState(() {
        isLoading = false;
      });

      navigationController.resetNavigation();
      registerController.currentLocaleName = '';

      if (registerController.codeController.text != '') {
        GeneralConfigModel? generalConfigMode = await secureStoreMixin
            .getGeneralConfigByName("user_received_sower_invitation_code_ooz");
        registerController.cleanTextEditingControllers();
        Navigator.of(context).pushNamed(
          PageRoute.Page.celebration.route,
          arguments: {
            "returnToPageWithArgs": {
              'currentPageName': registerController.returnToPage
            },
            "name": registerController.nameController.text,
            "goal": "invitationCode",
            "balance": registerController.formatNumber(
                generalConfigMode?.value ?? 0, Platform.localeName),
          },
        );
      } else {
        registerController.cleanTextEditingControllers();
        Navigator.of(context).pushNamedAndRemoveUntil(
          PageRoute.Page.homeScreen.route,
          (Route<dynamic> route) => false,
          arguments: {
            "returnToPageWithArgs": {
              'currentPageName': registerController.returnToPage
            }
          },
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.errorUpdateProfile),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: LoadingOverlay(
        isLoading: isLoading,
        child: Container(
          height: double.infinity,
          child: Center(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
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
                                      style: TextStyle(
                                          color: LightColors.blue,
                                          fontWeight: FontWeight.w500),
                                      focusNode:
                                          registerController.inputFocusNode,
                                      textAlign: TextAlign.left,
                                      controller: registerController
                                          .geolocationController,
                                      keyboardType: TextInputType.number,
                                      autofocus: false,
                                      decoration: GlobalConstants.of(context)
                                          .loginInputTheme(registerController
                                              .geolocationMessage)
                                          .copyWith(
                                              prefixIcon: Icon(
                                            FeatherIcons.mapPin,
                                            color: registerController
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
                                    visible: !isLoadingLocation &&
                                        registerController
                                            .geolocationErrorMessage.isNotEmpty,
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: GlobalConstants.of(context)
                                              .spacingNormal,
                                          bottom: GlobalConstants.of(context)
                                              .spacingSmall,
                                        ),
                                        child: Text(
                                          registerController
                                                  .geolocationErrorMessage +
                                              AppLocalizations.of(context)!
                                                  .tryToRetrieveYourCurrentLocationClickingByGetLocationAgain,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: isLoadingLocation,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: GlobalConstants.of(context)
                                            .spacingNormal,
                                        bottom: GlobalConstants.of(context)
                                            .spacingSmall,
                                      ),
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: registerController
                                            .geolocationErrorMessage.isNotEmpty
                                        ? GlobalConstants.of(context)
                                            .spacingNormal
                                        : GlobalConstants.of(context)
                                            .spacingLarge,
                                  ),
                                  Visibility(
                                    visible: registerController
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
                                      onPressed: () async {
                                        isLoadingLocation = true;
                                        setState(() {});
                                        await registerController
                                            .getLocation(context);
                                        isLoadingLocation = false;
                                        setState(() {});
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
                                    visible: registerController
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
                                            isLoadingLocation
                                                ? Color(0xff5d7fbb)
                                                : Color(0xff003694)),
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            EdgeInsets.all(
                                                GlobalConstants.of(context)
                                                    .spacingNormal)),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.conclude,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (!isLoadingLocation) {
                                      _register();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
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
