import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:ootopia_app/data/utils/string-utils.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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

  AuthStore authStore = AuthStore();
  Future<void> getTags() async {
    var getAllTags = await this.authStore.interestsTagsrepository.getTags();
    authStore.isLoading = false;
    setState(() {
      authStore.allTags.addAll(getAllTags);
    });
  }

  @override
  void initState() {
    super.initState();
    getTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: LoadingOverlay(
          isLoading: authStore.isLoading,
          child: authStore.isLoading
              ? Container()
              : CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 33,
                          ),
                          Text(
                            'Favorite Themes',
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
                              visible: authStore.selectedTags.isEmpty,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Select the hashtags that correspond to the themes you want to explore and learn.',
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
                                    'Select at least 1 hashtag',
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
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Observer(builder: (_) {
                                      return AlertDialog(
                                        title: Text(
                                          AppLocalizations.of(context)!
                                              .pleaseSelectAtLeast1Tag,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                onChanged: (value) {
                                                  authStore.searchTags(value);
                                                },
                                                decoration:
                                                    GlobalConstants.of(context)
                                                        .loginInputTheme(''),
                                              ),
                                              Divider(),
                                              Wrap(
                                                direction: Axis.horizontal,
                                                spacing: 1,
                                                children:
                                                    authStore.allTags.map((e) {
                                                  return Observer(
                                                      builder:
                                                          (_) => ChoiceChip(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            45)),
                                                                    side: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Color(
                                                                            0xffE0E1E2))),
                                                                label: Text(
                                                                  '${e.name}',
                                                                  style: TextStyle(
                                                                      color: e.seletedTag
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .grey),
                                                                ),
                                                                selectedColor:
                                                                    Color(
                                                                        0xff03145C),
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                selected: e
                                                                    .seletedTag,
                                                                onSelected: (bool
                                                                    selected) {
                                                                  e.seletedTag =
                                                                      selected;

                                                                  if (selected) {
                                                                    authStore
                                                                        .selectedTags
                                                                        .add(e);
                                                                  } else {
                                                                    authStore
                                                                        .selectedTags
                                                                        .remove(
                                                                            e);
                                                                  }
                                                                },
                                                              ));
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                authStore.selectedTags.clear();
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Color(0xff018F9C),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              child: Text(
                                                'Confirm',
                                                style: TextStyle(
                                                    color: Color(0xff018F9C),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              )),
                                        ],
                                      );
                                    });
                                  });
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
                                          'Select hashtags',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Observer(builder: (context) {
                                      return Visibility(
                                        visible:
                                            authStore.selectedTags.isNotEmpty,
                                        child: Text(
                                          '${authStore.selectedTags.length} Tags Selected',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    })
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Observer(builder: (context) {
                            return Visibility(
                              visible: authStore.selectedTags.isNotEmpty,
                              child: Wrap(
                                direction: Axis.horizontal,
                                spacing: 1,
                                children: authStore.selectedTags.map((e) {
                                  return ChoiceChip(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(45)),
                                        side: BorderSide(
                                            width: 1,
                                            color: Color(0xffE0E1E2))),
                                    label: Text(
                                      '${e.name}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    selectedColor: Color(0xff03145C),
                                    backgroundColor: Colors.white,
                                    selected: e.active,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        if (selected) {
                                          authStore.selectedTags.remove(e);
                                        }
                                        e.active = selected;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            );
                          }),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    GlobalConstants.of(context).spacingLarge,
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
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(
                                            GlobalConstants.of(context)
                                                .spacingNormal))),
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .continueAccess,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            )))),
                                onPressed: () {},
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
