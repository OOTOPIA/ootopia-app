import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/auth/register_second_phase/register_second_phase_controller.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPhase2TopInterestsPage extends StatefulWidget {
  final Map<String, dynamic> args;

  RegisterPhase2TopInterestsPage(this.args);

  @override
  _RegisterPhase2TopInterestsPageState createState() =>
      _RegisterPhase2TopInterestsPageState();
}

class _RegisterPhase2TopInterestsPageState
    extends State<RegisterPhase2TopInterestsPage> with SecureStoreMixin {
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  RegisterSecondPhaseController controller =
      RegisterSecondPhaseController.getInstance();

  @override
  void initState() {
    super.initState();
    controller.getTags();
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
    bool existTagsSelected = false;
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
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 33,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.favoriteThemes,
                                  style: TextStyle(
                                    color: Color(0xff03145C),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
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
                                          AppLocalizations.of(context)!.selectTheHashtagsThatCorrespondToTheThemesYouWantToExploreAndLearn
                                         ,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Text(
                                           AppLocalizations.of(context)!.selectAtLeastOneHashtag
                                          ,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height: 8,
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
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.add),
                                              Text(
                                                AppLocalizations.of(context)!.selectHashtags,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Visibility(
                                            visible: existTagsSelected,
                                            child: Text(
                                              '${controller.selectedTags.length}'+AppLocalizations.of(context)!.tagsSelected,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: controller.selectedTags.length != 0,
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 1,
                                    children:
                                        controller.selectedTags.map((tag) {
                                      return Container(
                                        height: 40,
                                        margin: EdgeInsets.all(5),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 12),
                                        decoration: BoxDecoration(
                                            color: Color(0xff03145C),
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            shape: BoxShape.rectangle),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${tag.name}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            GestureDetector(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16),
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
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: GlobalConstants.of(context).spacingNormal,
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
                                          Color(0xff003694)),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
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
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          )))),
                              onPressed: () {},
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
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      title: Text(
        AppLocalizations.of(context)!.pleaseSelectAtLeast1Tag,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              onChanged: (value) {
                controller.filterTagsByText(
                    text: value, update: () => setState(() {}));
              },
              decoration: GlobalConstants.of(context).loginInputTheme(''),
            ),
            Divider(),
            Wrap(
              direction: Axis.horizontal,
              spacing: 1,
              children: controller.filterTags.map((tag) {
                return ChoiceChip(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(45)),
                      side: BorderSide(width: 1, color: Color(0xffE0E1E2))),
                  label: Text(
                    '${tag.name}',
                    style: TextStyle(
                        color: tag.seletedTag ? Colors.white : Colors.grey),
                  ),
                  selectedColor: Color(0xff03145C),
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
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(
                  color: Color(0xff018F9C),
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            )),
        TextButton(
            onPressed: () {
              setState(() {});
              Navigator.of(context).pop();
            },
            child: Text(
              AppLocalizations.of(context)!.confirm,
              style: TextStyle(
                  color: Color(0xff018F9C),
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            )),
      ],
    );
  }
}
