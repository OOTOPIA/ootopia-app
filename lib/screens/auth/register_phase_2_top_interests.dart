import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/auth/register_second_phase/register_second_phase_controller.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/theme/light/colors.dart';

class RegisterPhase2TopInterestsPage extends StatefulWidget {
  final Map<String, dynamic> args;

  RegisterPhase2TopInterestsPage(this.args);

  @override
  _RegisterPhase2TopInterestsPageState createState() =>
      _RegisterPhase2TopInterestsPageState();
}

class _RegisterPhase2TopInterestsPageState
    extends State<RegisterPhase2TopInterestsPage>
    with SecureStoreMixin, WidgetsBindingObserver {
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  RegisterSecondPhaseController controller =
      RegisterSecondPhaseController.getInstance();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    Future.delayed(Duration.zero).then((_) async {
      await controller.updateLocalName();
      setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      await controller.updateLocalName();
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
                          fontSize:
                              Theme.of(context).textTheme.subtitle1!.fontSize,
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
      body: LoadingOverlay(
        isLoading: controller.authStore.isLoading,
        child: controller.authStore.isLoading
            ? Container()
            : CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
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
                                    visible:
                                        controller.selectedTags.length == 0,
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
                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return MyDialog();
                                        });

                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        bottom: GlobalConstants.of(context)
                                            .spacingNormal),
                                    height: 57,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: GlobalConstants.of(context)
                                            .spacingSmall,
                                        vertical: 0),
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
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: GlobalConstants.of(
                                                            context)
                                                        .spacingSmall),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 31,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .searchForAHashtag,
                                                style: GoogleFonts.roboto(
                                                    color:
                                                        LightColors.blackText,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1!
                                                        .fontSize),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: GlobalConstants.of(context)
                                              .spacingSmall,
                                        ),
                                        Visibility(
                                          visible:
                                              controller.selectedTags.length >
                                                  0,
                                          child: Expanded(
                                            child: Text(
                                              '${controller.selectedTags.length} ' +
                                                  AppLocalizations.of(context)!
                                                      .tagsSelected,
                                              overflow: TextOverflow.clip,
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.roboto(
                                                color: Colors.grey,
                                                fontSize: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .fontSize,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: controller.selectedTags.length != 0,
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    spacing: GlobalConstants.of(context)
                                        .spacingSmall,
                                    children:
                                        controller.selectedTags.map((tag) {
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
                                                  if (tag.seletedTag) {
                                                    tag.seletedTag = false;
                                                    controller.selectedTags
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
                            visible: controller.selectedTags.isNotEmpty,
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
                                                BorderRadius.circular(25.0),
                                            side: BorderSide.none)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            LightColors.blue),
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
                                    if (controller.selectedTags.isNotEmpty) {
                                      await controller.updateUser();

                                      setState(() {});

                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                        PageRoute.Page.homeScreen.route,
                                        (Route<dynamic> route) => false,
                                      );
                                    }
                                  } catch (e) {
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

class MyDialog extends StatefulWidget {
  MyDialog();

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  RegisterSecondPhaseController controller =
      RegisterSecondPhaseController.getInstance();

  @override
  void initState() {
    super.initState();
    controller.filterTags = controller.allTags;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.symmetric(
          horizontal: GlobalConstants.of(context).spacingNormal),
      titleTextStyle: TextStyle(
        fontSize: GlobalConstants.of(context).screenHorizontalSpace,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      title: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.pleaseSelectAtLeast1Tag,
          ),
          SizedBox(
            height: GlobalConstants.of(context).intermediateSpacing,
          ),
          TextFormField(
            style: TextStyle(height: 2.5),
            onChanged: (value) {
              controller.filterTagsByText(
                  text: value, update: () => setState(() {}));
            },
            decoration: GlobalConstants.of(context).loginInputTheme(
                AppLocalizations.of(context)!.selectAtLeastOneHashtag),
          ),
          SizedBox(
            height: GlobalConstants.of(context).spacingMedium,
          ),
          Container(
            color: LightColors.grey.withOpacity(.3),
            width: double.infinity,
            height: 1,
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 26,
            ),
            Wrap(
              direction: Axis.horizontal,
              spacing: GlobalConstants.of(context).spacingSmall,
              children: controller.filterTags.map((tag) {
                return ChoiceChip(
                  padding: EdgeInsets.symmetric(
                      horizontal: GlobalConstants.of(context).spacingNormal,
                      vertical: 0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(45)),
                      side: BorderSide(width: 1, color: Color(0xffE0E1E2))),
                  label: Text('${tag.name}',
                      style: GoogleFonts.roboto(
                          color: tag.seletedTag
                              ? Colors.white
                              : LightColors.blackText.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          fontSize:
                              Theme.of(context).textTheme.headline5!.fontSize)),
                  selectedColor: LightColors.darkBlue,
                  backgroundColor: Colors.white,
                  selected: tag.seletedTag,
                  onSelected: (bool selected) {
                    setState(() {
                      tag.seletedTag = selected;
                    });
                    if (selected) {
                      controller.selectedTags.add(tag);
                    } else {
                      controller.selectedTags.remove(tag);
                    }
                  },
                );
              }).toList(),
            ),
            SizedBox(
              height: GlobalConstants.of(context).screenHorizontalSpace,
            ),
          ],
        ),
      ),
      actions: [
        Column(
          children: [
            Container(
              color: LightColors.grey.withOpacity(.3),
              width: double.infinity,
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: GlobalConstants.of(context).spacingSmall),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                            color: Color(0xff018F9C),
                            fontWeight: FontWeight.w500,
                            fontSize: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .fontSize),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: GlobalConstants.of(context).spacingSmall),
                  child: TextButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.confirm,
                        style: TextStyle(
                            color: Color(0xff018F9C),
                            fontWeight: FontWeight.w500,
                            fontSize: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .fontSize),
                      )),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
