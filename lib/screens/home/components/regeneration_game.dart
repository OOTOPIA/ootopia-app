import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class RegenerationGame extends StatefulWidget {
  RegenerationGame({Key? key}) : super(key: key);

  @override
  _RegenerationGameState createState() => _RegenerationGameState();
}

class _RegenerationGameState extends State<RegenerationGame> {
  Map<String, IconData> gameProgress = {
    'personal': FeatherIcons.user,
    'city': FeatherIcons.mapPin,
    'global': FeatherIcons.globe,
  };

  bool showDetailedGoal = false;
  String detailedGoalType = "";

  late HomeStore homeStore;
  late AuthStore authStore;

  @override
  Widget build(BuildContext context) {
    homeStore = Provider.of<HomeStore>(context);
    authStore = Provider.of<AuthStore>(context);
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
            child: showDetailedGoal
                ? detailedGoal
                : Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        onTap: () => {}, //Saiba mais
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            right: GlobalConstants.of(context).spacingNormal,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.regenerationGame,
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
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            gameIconProgress("personal"),
                            gameIconProgress("city"),
                            gameIconProgress("global"),
                          ],
                        ),
                      )
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
            showDetailedGoal = !showDetailedGoal;
          });
        },
        child: Container(
          margin: EdgeInsets.only(top: 6),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.all(Radius.circular(100)),
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
                        radius: 40,
                        lineWidth: 2,
                        backgroundColor: Theme.of(context).backgroundColor,
                        percent: detailedGoalType == "personal" &&
                                homeStore.dailyGoalStats != null
                            ? (homeStore.dailyGoalStats!
                                    .percentageOfDailyGoalAchieved /
                                100)
                            : 0,
                        progressColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 6,
                  top: 6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                            text: AppLocalizations.of(context)!.personalGoal +
                                ": ",
                            style: Theme.of(context).textTheme.subtitle2!,
                            children: [
                              TextSpan(
                                text:
                                    "${authStore.currentUser!.dailyLearningGoalInMinutes}m",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                              )
                            ]),
                      ),
                    ),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          text:
                              AppLocalizations.of(context)!.accomplished + ": ",
                          style: Theme.of(context).textTheme.subtitle2!,
                          children: [
                            TextSpan(
                              text: homeStore.totalAppUsageTimeSoFar,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
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
                    top: 6,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.oozPartialBalance,
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              fontSize: 12,
                            ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            homeStore.dailyGoalStats != null
                                ? "${homeStore.dailyGoalStats!.accumulatedOOZ}"
                                : "0,00",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(fontSize: 12),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget gameIconProgress(String type) {
    goToCelebrationCity() async {//for tests
      await Navigator.of(context).pushNamed(
        PageRoute.Page.celebration.route,
        arguments: {
          "name": "Belo Horizonte!",
          "goal": "city",
          "balance": "17,25"
        },
      );
    }

    goToCelebrationGlobal() async {//for tests
      await Navigator.of(context).pushNamed(
        PageRoute.Page.celebration.route,
        arguments: {
          "name": "Luis Reis",
          "goal": "global",
          "balance": "17,25"
        },
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (authStore.currentUser != null) {
            detailedGoalType = type;
            if (detailedGoalType == 'city') {
              goToCelebrationCity();
            } else if (detailedGoalType == 'global')  {
              goToCelebrationGLobal();
            }
            else {
              showDetailedGoal = true;
            }
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Stack(
          children: [
            Container(
              width: 40,
              height: 40,
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
                radius: 40,
                lineWidth: 2,
                backgroundColor: Theme.of(context).primaryColorDark,
                percent: type == "personal" && homeStore.dailyGoalStats != null
                    ? (homeStore.dailyGoalStats!.percentageOfDailyGoalAchieved /
                        100)
                    : 0,
                progressColor: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
