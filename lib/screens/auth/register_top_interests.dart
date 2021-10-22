import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/auth/register_controller/register_controller.dart';

import 'package:ootopia_app/screens/components/interests_tags_modal/interests_tags_controller.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class RegisterTopInterestsScreen extends StatefulWidget {
  final Map<String, dynamic>? args;

  const RegisterTopInterestsScreen([this.args]);

  @override
  _RegisterTopInterestsScreenState createState() =>
      _RegisterTopInterestsScreenState();
}

class _RegisterTopInterestsScreenState extends State<RegisterTopInterestsScreen>
    with SecureStoreMixin, WidgetsBindingObserver {
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  SmartPageController pageController = SmartPageController.getInstance();

  RegisterSecondPhaseController registerController =
      RegisterSecondPhaseController.getInstance();
  SmartPageController navigationController = SmartPageController.getInstance();
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    Future.delayed(Duration.zero).then((_) async {
      registerController.currentLocaleName = '';
      await registerController.updateLocalName();
      setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      await registerController.updateLocalName();
      setState(() {});
    }
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
            left: GlobalConstants.of(context).smallIntermediateSpacing,
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
                    style: GoogleFonts.roboto(
                      fontSize: Theme.of(context).textTheme.subtitle1!.fontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: LoadingOverlay(
        isLoading: registerController.authStore.isLoading || isloading,
        child: registerController.authStore.isLoading
            ? Container()
            : CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    fillOverscroll: true,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              GlobalConstants.of(context).intermediateSpacing),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height:
                                      GlobalConstants.of(context).spacingMedium,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.favoriteThemes,
                                  style: GoogleFonts.roboto(
                                    color: LightColors.darkBlue,
                                    fontSize: GlobalConstants.of(context)
                                        .screenHorizontalSpace,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      GlobalConstants.of(context).spacingSmall,
                                ),
                                Visibility(
                                    visible: registerController
                                            .selectedTags.length ==
                                        0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .selectTheHashtagsThatCorrespondToTheThemesYouWantToExploreAndLearn,
                                          style: GoogleFonts.roboto(
                                            color: Colors.grey,
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .fontSize,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: GlobalConstants.of(context)
                                              .spacingSmall,
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                        ),
                                        SizedBox(
                                          height: GlobalConstants.of(context)
                                              .spacingNormal,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .selectAtLeastOneHashtag,
                                          style: GoogleFonts.roboto(
                                            color: Colors.grey,
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .fontSize,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height:
                                      GlobalConstants.of(context).spacingSmall,
                                ),
                                InkWell(
                                  onTap: () async {
                                    InterestsTagsController
                                        interestsTagsController =
                                        InterestsTagsController();
                                    var result =
                                        await interestsTagsController.show(
                                      context,
                                      registerController.allTags,
                                      registerController.selectedTags,
                                    );

                                    if (result != null) {
                                      registerController.selectedTags = result;
                                    }

                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        bottom: GlobalConstants.of(context)
                                            .spacingNormal),
                                    height: 57,
                                    padding: EdgeInsets.symmetric(vertical: 0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: LightColors.grey,
                                        width: 0.25,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 5, left: 8),
                                              child: ImageIcon(
                                                  AssetImage(
                                                      "assets/icons/icon_add.png"),
                                                  size: 31),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .searchForAHashtag,
                                              overflow: TextOverflow.clip,
                                              style: GoogleFonts.roboto(
                                                  color: LightColors.blackText,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Visibility(
                                            visible: registerController
                                                    .selectedTags.length >
                                                0,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 3, right: 10),
                                              child: Text(
                                                registerController.selectedTags
                                                            .length >
                                                        1
                                                    ? '${registerController.selectedTags.length} ' +
                                                        AppLocalizations.of(
                                                                context)!
                                                            .tagsSelected
                                                    : '${registerController.selectedTags.length} ' +
                                                        AppLocalizations.of(
                                                                context)!
                                                            .tagSelected,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                textAlign: TextAlign.right,
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: GoogleFonts.roboto(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      registerController.selectedTags.length !=
                                          0,
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    spacing: GlobalConstants.of(context)
                                        .spacingSmall,
                                    children: registerController.selectedTags
                                        .map((tag) {
                                      return Container(
                                        height: 38,
                                        margin: EdgeInsets.only(
                                            bottom: GlobalConstants.of(context)
                                                .spacingSmall),
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                GlobalConstants.of(context)
                                                    .intermediateSpacing,
                                            vertical:
                                                GlobalConstants.of(context)
                                                    .smallIntermediateSpacing),
                                        decoration: BoxDecoration(
                                            color: LightColors.darkBlue,
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            shape: BoxShape.rectangle),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${tag.name}',
                                              style: GoogleFonts.roboto(
                                                fontSize: Theme.of(context)
                                                    .textTheme
                                                    .headline5!
                                                    .fontSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            GestureDetector(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: GlobalConstants.of(
                                                            context)
                                                        .spacingNormal),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  if (tag.selectedTag == true) {
                                                    tag.selectedTag = false;
                                                    registerController
                                                        .selectedTags
                                                        .remove(tag);
                                                  }
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: registerController.selectedTags.isNotEmpty,
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    GlobalConstants.of(context).spacingNormal,
                              ),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                            side: BorderSide.none)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            LightColors.blue),
                                    minimumSize: MaterialStateProperty.all(
                                      Size(60, 55),
                                    ),
                                    elevation:
                                        MaterialStateProperty.all<double>(0.0),
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(
                                            GlobalConstants.of(context)
                                                .spacingNormal))),
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .conclude,
                                            style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .fontSize,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            )))),
                                onPressed: () async {
                                  try {
                                    if (registerController
                                        .selectedTags.isNotEmpty) {
                                      setState(() {
                                        isloading = true;
                                      });
                                      await registerController.registerUser();

                                      setState(() {
                                        isloading = false;
                                      });

                                      navigationController.resetNavigation();

                                      if (registerController
                                              .codeController.text !=
                                          '') {
                                        registerController
                                            .cleanTextEditingControllers();

                                        Navigator.of(context).pushNamed(
                                          PageRoute.Page.celebration.route,
                                          arguments: {
                                            "returnToPageWithArgs": {
                                              'currentPageName':
                                                  registerController
                                                      .returnToPage
                                            },
                                            "name": registerController
                                                .nameController.text,
                                            "goal": "invitationCode",
                                            "balance": "15,00",
                                          },
                                        );
                                      } else {
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                          PageRoute.Page.homeScreen.route,
                                          (Route<dynamic> route) => false,
                                          arguments: {
                                            "returnToPageWithArgs": {
                                              'currentPageName':
                                                  registerController
                                                      .returnToPage
                                            }
                                          },
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    setState(() {
                                      isloading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .errorUpdateProfile),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
