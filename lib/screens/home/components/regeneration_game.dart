import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/data/models/general_config/general_config_model.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/edit_profile_screen/edit_profile_store.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/home/components/page_view_controller.dart';
import 'package:ootopia_app/screens/learning_tracks/learning_tracks_store.dart';
import 'package:ootopia_app/screens/learning_tracks/view_learning_tracks/view_learning_tracks.dart';
import 'package:ootopia_app/screens/persona_level/personal_level.dart';
import 'package:ootopia_app/screens/regenerarion_game_learning_alert/regenerarion_game_learning_alert.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class RegenerationGame extends StatefulWidget {
  RegenerationGame({Key? key}) : super(key: key);

  @override
  _RegenerationGameState createState() => _RegenerationGameState();
}

class _RegenerationGameState extends State<RegenerationGame>
    with SecureStoreMixin {
  Map<String, String> gameProgress = {
    'personal': 'assets/icons/user1.svg',
    'city': 'assets/icons/local1.svg',
    'global': 'assets/icons/globo1.svg',
  };

  String detailedGoalType = "";

  late HomeStore homeStore;
  late AuthStore authStore;
  late EditProfileStore editProfileStore;
  final currencyFormatter = NumberFormat('#,##0.00', 'ID');

  double gameProgressIconSize = 40;
  double screenWidth = 0;

  double detailedGoalIconPosition = 0;
  bool celebratePageIsOpen = false;

  bool clickedInPersonalDialogOpened = false;

  SmartPageController controller = SmartPageController.getInstance();
  LearningTracksModel? welcomeGuideLearningTrack;
  LearningTracksStore learningTracksStore = LearningTracksStore();
  SharedPreferences? prefs;
  bool showMap = false;
  bool showPersonal = false;
  bool showLocal = false;
  bool showGlobo = false;
  var typeSelected;

  late LinearGradient userLinear;
  late LinearGradient pinLinear;
  late LinearGradient globoLinear;

  late Map<String, LinearGradient> gameProgressColors;
  double valueOoz = 0;

  @override
  void initState() {
    userLinear = LinearGradient(
      colors: [Color(0xff00A5FC), Color(0xff006FAA)],
    );
    pinLinear = LinearGradient(
      colors: [Color(0xff0072C5), Color(0xff003963)],
    );
    globoLinear = LinearGradient(
      colors: [Color(0xff3159C7), Color(0xff011344)],
    );

    gameProgressColors = {
      'personal': userLinear,
      'city': pinLinear,
      'global': globoLinear,
    };
    getOozPerMinute();
    super.initState();
    editProfileStore = Provider.of<EditProfileStore>(context, listen: false);
    editProfileStore.getUser();
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      welcomeGuideLearningTrack = await learningTracksStore.getWelcomeGuide();
    });
    Future.delayed(Duration(milliseconds: 300), () {
      _resetDetailedIconPosition();
    });

    controller.addListener(() {
      showMap =
          controller.currentBottomIndex == PageViewController.TAB_UNSELECTED;
      if (showPersonal || showLocal || showGlobo) {
        showPersonal = false;
        showLocal = false;
        showGlobo = false;
      }
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    homeStore = Provider.of<HomeStore>(context);
    authStore = Provider.of<AuthStore>(context);
    screenWidth = MediaQuery.of(context).size.width;
    if (!celebratePageIsOpen) {
      _checkShowCelebratePage();
    }
    return Observer(
      builder: (_) => Column(
        children: [
          Container(
            width: double.infinity,
            height: 1,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          Container(
            width: double.infinity,
            height: 59,
            decoration: BoxDecoration(
              color: Color(0xffAEAEAE).withOpacity(0.17),
            ),
            padding: EdgeInsets.only(
              left: getEdgeInsetsHorizontalSize,
              right: getEdgeInsetsHorizontalSize,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: double.infinity,
                  height: 59,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            if (editProfileStore.currentUser != null &&
                                !showPersonal &&
                                !showLocal &&
                                !showGlobo) {
                              showModalBottomSheet(
                                  barrierColor: Colors.black.withAlpha(1),
                                  context: context,
                                  backgroundColor: Colors.black.withAlpha(1),
                                  builder: (BuildContext context) {
                                    return SnackBarWidget(
                                      menu: AppLocalizations.of(context)!
                                          .regenerationGame,
                                      text: AppLocalizations.of(context)!
                                          .theDailyGoalChosenWas10MinutesAndIsBeingUsedForTheRegenerationGame
                                          .replaceAll('%GOAL_CHOSEN%',
                                              '${editProfileStore.currentUser!.dailyLearningGoalInMinutes!}'),
                                      buttons: [
                                        ButtonSnackBar(
                                          text: AppLocalizations.of(context)!
                                              .learnMore,
                                          onTapAbout: () => onTapLearnMore(),
                                          closeOnTapAbout: true,
                                        )
                                      ],
                                      marginBottom: true,
                                    );
                                  });
                            }
                          }, //Saiba mais
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              right: GlobalConstants.of(context).spacingNormal,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .regenerationGame,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color,
                                      ),
                                ),
                                GestureDetector(
                                  onTap: () => onTapLearnMore(),
                                  child: Text(
                                    subtext(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: LightColors.blue),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          gameIconProgress("personal",
                              (showPersonal || showMap), Color(0xff00A5FC)),
                          gameIconProgress(
                              "city", showLocal, Color(0xff0072C5)),
                          gameIconProgress(
                              "global", showGlobo, Color(0xff012588)),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: showMap,
            child: Container(
              width: double.infinity,
              decoration:
                  BoxDecoration(color: Theme.of(context).primaryColorLight),
              child: newDetailedGoal(),
            ),
          ),
          if (showMap) ...[
            PersonaLevel(percent: percentTimeCompleted()),
          ] else if (showPersonal) ...[
            Container(
                height: MediaQuery.of(context).size.height - 125,
                child: RegenerationGameLearningAlert(typeSelected)),
          ] else if (showLocal) ...[
            Container(
                height: MediaQuery.of(context).size.height - 125,
                child: RegenerationGameLearningAlert(typeSelected)),
          ] else if (showGlobo) ...[
            Container(
                height: MediaQuery.of(context).size.height - 125,
                child: RegenerationGameLearningAlert(typeSelected)),
          ]
        ],
      ),
    );
  }

  Widget newDetailedGoal() {
    int minutes = authStore.currentUser?.dailyLearningGoalInMinutes ?? 0;
    double amountOzzWillReceive = valueOoz * minutes;
    return InkWell(
      onTap: () {
        setState(() {
          showMap = false;
          _resetDetailedIconPosition();
        });
        Future.delayed(Duration(milliseconds: 100), () {
          setState(() {
            showGlobo = false;
          });
        });
      },
      child: Container(
        height: 66,
        child: Column(
          children: [
            Container(
              height: 0.6,
              color: Color(0xffB0B0B0),
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              padding: EdgeInsets.only(
                left: getEdgeInsetsHorizontalSize,
                right: getEdgeInsetsHorizontalSize,
              ),
              margin: EdgeInsets.only(top: 2),
              height: 59,
              width: MediaQuery.of(context).size.width,
              child: SizedBox(
                width: screenWidth -
                    isSmallPhone(
                        GlobalConstants.of(context).screenHorizontalSpace * 2),
                child: Stack(
                  children: [
                    AnimatedOpacity(
                      opacity: showMap ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 150),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 6,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    AppLocalizations.of(context)!.yourDailyGoal,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width <
                                                  380
                                              ? 12
                                              : 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    AppLocalizations.of(context)!.achieved,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width <
                                                  380
                                              ? 12
                                              : 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .oozCreditsYouWillReceive,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width <
                                                  380
                                              ? 12
                                              : 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    (authStore.currentUser == null
                                        ? ""
                                        : "${authStore.currentUser!.dailyLearningGoalInMinutes}min"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width <
                                                  380
                                              ? 12
                                              : 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                  Text(
                                    timeAchieved(
                                        homeStore.totalAppUsageTimeSoFar),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width <
                                                  380
                                              ? 12
                                              : 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/ooz_mini_blue.svg',
                                        width: 18,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Text(
                                          homeStore.dailyGoalStats != null
                                              ? currencyFormatter
                                                  .format(amountOzzWillReceive)
                                              : "0,00",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width <
                                                        380
                                                    ? 12
                                                    : 14,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
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

  Widget gameIconProgress(String type, selected, colorSelected) {
    return GestureDetector(
      onTap: () {
        //REFATORADO
        if (authStore.currentUser == null) {
          Navigator.of(context).pushNamed(PageRoute.Page.loginScreen.route);
        } else {
          if (type == 'personal') {
            bool dontShowAgainRegenerationGamePega =
                prefs?.getBool('dontShowAgainRegenerationGamePega') ?? false;
            if (dontShowAgainRegenerationGamePega) {
              if (showMap) {
                controller.currentBottomIndex =
                    PageViewController.TAB_INDEX_TIMELINE;
                controller.refreshViews();
                controller.showBottomNavigationBar();
                showMap = false;
                setState(() {});
              } else {
                setState(() {
                  controller.currentBottomIndex =
                      PageViewController.TAB_UNSELECTED;
                  controller.showBottomNavigationBar();
                  controller.refreshViews();
                  showGlobo = false;
                  showPersonal = false;
                  showLocal = false;
                  typeSelected = {"type": type, "context": context};
                });
                Future.delayed(Duration(milliseconds: 25), () {
                  setState(() {
                    showMap = true;
                  });
                });
              }
            } else {
              if (showPersonal || showMap) {
                controller.currentBottomIndex =
                    PageViewController.TAB_INDEX_TIMELINE;
                controller.refreshViews();
                controller.showBottomNavigationBar();
                showPersonal = false;
                setState(() {});
              } else {
                setState(() {
                  controller.currentBottomIndex =
                      PageViewController.HIDE_BOTTOMBAR;
                  controller.hideBottomNavigationBar();
                  controller.refreshViews();
                  showGlobo = false;
                  showMap = false;
                  showLocal = false;
                  typeSelected = {"type": type, "context": context};
                });
                Future.delayed(Duration(milliseconds: 25), () {
                  setState(() {
                    showPersonal = true;
                  });
                });
              }
            }
          } else if (type == 'city') {
            if (showLocal) {
              controller.currentBottomIndex =
                  PageViewController.TAB_INDEX_TIMELINE;
              controller.refreshViews();
              controller.showBottomNavigationBar();
              showLocal = false;
              setState(() {});
            } else {
              setState(() {
                controller.currentBottomIndex =
                    PageViewController.HIDE_BOTTOMBAR;
                controller.refreshViews();
                showGlobo = false;
                showMap = false;
                showPersonal = false;
                typeSelected = {"type": type, "context": context};
              });
              Future.delayed(Duration(milliseconds: 25), () {
                controller.currentBottomIndex =
                    PageViewController.HIDE_BOTTOMBAR;
                controller.refreshViews();
                controller.hideBottomNavigationBar();
                setState(() {
                  controller.currentBottomIndex =
                      PageViewController.HIDE_BOTTOMBAR;
                  controller.refreshViews();
                  controller.hideBottomNavigationBar();
                  showLocal = true;
                });
              });
            }
          } else if (type == 'global') {
            if (showGlobo) {
              controller.currentBottomIndex =
                  PageViewController.TAB_INDEX_TIMELINE;
              controller.refreshViews();
              controller.showBottomNavigationBar();
              showGlobo = false;
              setState(() {});
            } else {
              setState(() {
                controller.currentBottomIndex =
                    PageViewController.TAB_INDEX_TIMELINE;
                controller.refreshViews();
                showLocal = false;
                showMap = false;
                showPersonal = false;
                typeSelected = {"type": type, "context": context};
              });
              Future.delayed(Duration(milliseconds: 10), () {
                controller.currentBottomIndex =
                    PageViewController.HIDE_BOTTOMBAR;
                controller.refreshViews();
                controller.hideBottomNavigationBar();
                setState(() {
                  controller.currentBottomIndex =
                      PageViewController.HIDE_BOTTOMBAR;
                  controller.refreshViews();
                  controller.hideBottomNavigationBar();
                  showGlobo = true;
                });
              });
            }
          }
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 6),
        child: Stack(
          children: [
            Container(
              width: gameProgressIconSize,
              height: gameProgressIconSize,
              decoration: BoxDecoration(
                color:
                    selected ? colorSelected : Colors.white.withOpacity(0.35),
                borderRadius:
                    BorderRadius.all(Radius.circular(gameProgressIconSize)),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                gameProgress[type]!,
                height: selected ? 24 : 18,
                color:
                    selected ? Colors.white : Theme.of(context).iconTheme.color,
              ),
            ),
            Visibility(
              visible: !selected && type == 'personal',
              child: Positioned(
                top: 0,
                child: CircularPercentIndicator(
                    radius: gameProgressIconSize,
                    lineWidth: 2,
                    backgroundColor: Color(0XFFd4d4d4),
                    percent: percentTimeCompleted(),
                    linearGradient: gameProgressColors[type]),
              ),
            ),
            Visibility(
              visible: !selected && type != 'personal',
              child: Positioned(
                top: 0,
                child: CircularPercentIndicator(
                  radius: gameProgressIconSize,
                  lineWidth: 2,
                  backgroundColor: Color(0XFFd4d4d4),
                  progressColor: Color(0XFFd4d4d4),
                  percent: 1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _checkShowCelebratePage() {
    homeStore.readyToShowCelebratePage().then((bool ready) {
      if (ready) {
        setState(() {
          celebratePageIsOpen = true;
        });
        homeStore.setCelebratePageAlreadyOpened(true);
        _goToCelebrationPersonal();
      }
    });
  }

  void _goToCelebrationPersonal() async {
    //for tests
    await Navigator.of(context).pushNamed(
      PageRoute.Page.celebration.route,
      arguments: {
        "name": authStore.currentUser != null
            ? authStore.currentUser!.fullname
            : "",
        "goal": "personal",
        "balance": homeStore.dailyGoalStats != null
            ? "${currencyFormatter.format(homeStore.dailyGoalStats!.accumulatedOOZ)}"
            : "0,00",
      },
    );
  }

  void _resetDetailedIconPosition() {
    detailedGoalIconPosition = screenWidth - ((gameProgressIconSize + 6) * 4);
  }

  void getOozPerMinute() async {
    SecureStoreMixin secureStoreMixin = SecureStoreMixin();
    GeneralConfigModel? transferOozToPostLimitConfig = await secureStoreMixin
        .getGeneralConfigByName("user_reward_per_minute_of_timeline_view_time");

    valueOoz = transferOozToPostLimitConfig?.value ?? 0;
  }

  void openLearningTrack(LearningTracksModel learningTrack) {
    controller.insertPage(ViewLearningTracksScreen(
      {
        'list_chapters': learningTrack.chapters,
        'learning_tracks': learningTrack,
        'updateLearningTrack': updateWidget,
      },
    ));
  }

  void updateWidget() {
    setState(() {});
  }

  double isSmallPhone(double value) {
    if (MediaQuery.of(context).size.width < 380) return value / 2;
    return value;
  }

  double percentTimeCompleted() {
    if (homeStore.dailyGoalStats != null) {
      return (homeStore.percentageOfDailyGoalAchieved / 100);
    } else {
      return 0;
    }
  }

  String timeAchieved(time) {
    bool withSec = time.indexOf('s') != -1;
    if (time.isEmpty) {
      return "0h 0min 0s";
    } else if (withSec) {
      return time;
    } else {
      return time.substring(0, (time.lastIndexOf('') - 1));
    }
  }

  double get getEdgeInsetsHorizontalSize {
    return MediaQuery.of(context).size.width < 380
        ? 10
        : GlobalConstants.of(context).screenHorizontalSpace;
  }

  onTapLearnMore() async {
    if (welcomeGuideLearningTrack == null) {
      welcomeGuideLearningTrack = await learningTracksStore.getWelcomeGuide();
    }
    if (welcomeGuideLearningTrack != null &&
        !showMap &&
        !showPersonal &&
        !showPersonal &&
        !showLocal &&
        !showGlobo) {
      openLearningTrack(welcomeGuideLearningTrack!);
    }
  }

  String subtext() {
    if (showMap || showPersonal) {
      return AppLocalizations.of(context)!.personalLevel.toUpperCase();
    } else if (showLocal) {
      return AppLocalizations.of(context)!.cityLevel.toUpperCase();
    } else if (showGlobo) {
      return AppLocalizations.of(context)!.planetaryLevel.toUpperCase();
    } else {
      return AppLocalizations.of(context)!.learnMore;
    }
  }
}
