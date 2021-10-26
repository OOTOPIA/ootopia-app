import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/edit_profile_screen/edit_profile_store.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class RegenerationGame extends StatefulWidget {
  RegenerationGame({Key? key}) : super(key: key);

  @override
  _RegenerationGameState createState() => _RegenerationGameState();
}

class _RegenerationGameState extends State<RegenerationGame>
    with SecureStoreMixin {
  Map<String, IconData> gameProgress = {
    'personal': FeatherIcons.user,
    'city': FeatherIcons.mapPin,
    'global': FeatherIcons.globe,
  };

  bool showDetailedGoal = false;
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

  @override
  void initState() {
    super.initState();
    editProfileStore = Provider.of<EditProfileStore>(context, listen: false);
    editProfileStore.getUser();
    Future.delayed(Duration(milliseconds: 300), () {
      _resetDetailedIconPosition();
    });
  }

  _resetDetailedIconPosition() {
    detailedGoalIconPosition = screenWidth - ((gameProgressIconSize + 6) * 4);
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
            decoration:
                BoxDecoration(color: Theme.of(context).primaryColorLight),
            padding: EdgeInsets.only(
              left: GlobalConstants.of(context).screenHorizontalSpace,
              right: GlobalConstants.of(context).screenHorizontalSpace,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Visibility(
                  visible: showDetailedGoal,
                  child: Container(
                    width: double.infinity,
                    height: 59,
                    child: detailedGoal,
                  ),
                ),
                Visibility(
                  visible: !showDetailedGoal,
                  child: Container(
                    width: double.infinity,
                    height: 59,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Observer(builder: (context) {
                          return Expanded(
                            child: InkWell(
                              onTap: () async {
                                if (editProfileStore.currentUser != null) {
                                  showModalBottomSheet(
                                      barrierColor: Colors.black.withAlpha(1),
                                      context: context,
                                      backgroundColor:
                                          Colors.black.withAlpha(1),
                                      builder: (BuildContext context) {
                                        return SnackBarWidget(
                                          menu: AppLocalizations.of(context)!
                                              .regenerationGame,
                                          text: AppLocalizations.of(context)!
                                              .theDailyGoalChosenWas10MinutesAndIsBeingUsedForTheRegenerationGame
                                              .replaceAll('%GOAL_CHOSEN%',
                                                  '${editProfileStore.currentUser!.dailyLearningGoalInMinutes!}'),
                                          about: AppLocalizations.of(context)!
                                              .learnMore,
                                          marginBottom: true,
                                        );
                                      });
                                }
                              }, //Saiba mais
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 10,
                                  right:
                                      GlobalConstants.of(context).spacingNormal,
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
                                    Text(
                                      AppLocalizations.of(context)!.learnMore,
                                      style: Theme.of(context)
                                          .accentTextTheme
                                          .bodyText2!,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            gameIconProgress("personal"),
                            gameIconProgress("city"),
                            gameIconProgress("global"),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get detailedGoal => InkWell(
        onTap: () {
          setState(() {
            _resetDetailedIconPosition();
          });
          Future.delayed(Duration(milliseconds: 100), () {
            setState(() {
              showDetailedGoal = false;
            });
          });
        },
        child: Container(
          margin: EdgeInsets.only(top: 6),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: screenWidth -
                    (GlobalConstants.of(context).screenHorizontalSpace * 2),
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      left: detailedGoalIconPosition,
                      duration: Duration(milliseconds: 300),
                      child: AnimatedOpacity(
                        opacity: detailedGoalIconPosition > 0 ? 0 : 1,
                        duration: Duration(milliseconds: 150),
                        child: Stack(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                              ),
                              child: Center(
                                child: Icon(
                                  gameProgress[detailedGoalType],
                                  size: 20,
                                  color: Theme.of(context).backgroundColor,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 1,
                              left: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: CircularPercentIndicator(
                                  radius: gameProgressIconSize,
                                  lineWidth: 2,
                                  backgroundColor:
                                      Theme.of(context).backgroundColor,
                                  percent: detailedGoalType == "personal" &&
                                          homeStore.dailyGoalStats != null
                                      ? (homeStore
                                              .percentageOfDailyGoalAchieved /
                                          100)
                                      : 0,
                                  progressColor: Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: detailedGoalIconPosition > 0 ? 0 : 1,
                      duration: Duration(milliseconds: 150),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: gameProgressIconSize + 12,
                              top: 6,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                        text: AppLocalizations.of(context)!
                                                .personalGoal +
                                            ": ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                        children: [
                                          TextSpan(
                                            text: (authStore.currentUser == null
                                                ? ""
                                                : "${authStore.currentUser!.dailyLearningGoalInMinutes}m"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                          )
                                        ]),
                                  ),
                                ),
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      text: AppLocalizations.of(context)!
                                              .accomplished +
                                          ": ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      children: [
                                        TextSpan(
                                          text: homeStore.totalAppUsageTimeSoFar
                                                  .isEmpty
                                              ? "0h 0m 0s"
                                              : homeStore
                                                  .totalAppUsageTimeSoFar,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 7,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .oozPartialBalance,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            PageRoute.Page.aboutOOzCurrentScreen
                                                .route);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/ooz_mini_blue.svg',
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 6),
                                            child: Text(
                                              homeStore.dailyGoalStats != null
                                                  ? "${currencyFormatter.format(homeStore.dailyGoalStats!.accumulatedOOZ)}"
                                                  : "0,00",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
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
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget gameIconProgress(String type) {
    return GestureDetector(
      onTap: () {
        //TODO refatorar esse codigo em algum momento
        setState(() {
          if (homeStore.dailyGoalStats == null) {
            homeStore.getDailyGoalStats();
          }

          if (authStore.currentUser == null && type == 'city' ||
              type == 'global') {
            _goToRegenerationGameAlert(type);
            return;
          }

          if (authStore.currentUser == null &&
              !this.clickedInPersonalDialogOpened &&
              type == 'personal') {
            this.clickedInPersonalDialogOpened = true;

            _goToRegenerationGameAlert(type);
            return;
          }

          if (authStore.currentUser != null) {
            detailedGoalType = type;
            if (detailedGoalType == 'city') {
              _goToRegenerationGameAlert(type);
            } else if (detailedGoalType == 'global') {
              _goToRegenerationGameAlert(type);
            } else {
              if (authStore.currentUser!.personalDialogOpened == null ||
                  authStore.currentUser!.personalDialogOpened == false) {
                authStore.currentUser!.personalDialogOpened = true;

                _goToRegenerationGameAlert(type);
              }

              setState(() {
                showDetailedGoal = true;
              });
              Future.delayed(Duration(milliseconds: 100), () {
                setState(() {
                  detailedGoalIconPosition = 0;
                });
              });
            }
          } else {
            Navigator.of(context).pushNamed(PageRoute.Page.loginScreen.route);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 6),
        child: Stack(
          children: [
            Container(
              width: gameProgressIconSize,
              height: gameProgressIconSize,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              child: Center(
                child: Icon(
                  gameProgress[type],
                  size: 20,
                ),
              ),
            ),
            Positioned(
              //alignment: Alignment.center,
              top: 0,
              child: CircularPercentIndicator(
                radius: gameProgressIconSize,
                lineWidth: 2,
                backgroundColor: Theme.of(context).primaryColorDark,
                percent: type == "personal" && homeStore.dailyGoalStats != null
                    ? (homeStore.percentageOfDailyGoalAchieved / 100)
                    : 0,
                progressColor: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  _checkShowCelebratePage() {
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

  _goToCelebrationPersonal() async {
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

  _goToRegenerationGameAlert(String type) async {
    if (authStore.currentUser != null) {
      authStore.updateUserRegenerarionGameLearningAlert(type);
    }

    Navigator.of(context).pushNamed(
      PageRoute.Page.regenerarionGameLearningAlert.route,
      arguments: {"type": type, "context": context},
    );
  }

  _goToCelebrationCity() async {
    //for tests
    await Navigator.of(context).pushNamed(
      PageRoute.Page.celebration.route,
      arguments: {
        "name": "Belo Horizonte!",
        "goal": "city",
        "balance": "17,25"
      },
    );
  }

  _goToCelebrationGlobal() async {
    //for tests
    await Navigator.of(context).pushNamed(
      PageRoute.Page.celebration.route,
      arguments: {"name": "Luis Reis", "goal": "global", "balance": "17,25"},
    );
  }
}
