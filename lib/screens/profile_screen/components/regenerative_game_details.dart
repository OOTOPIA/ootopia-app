import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ootopia_app/shared/page-enum.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';
import 'package:provider/provider.dart';

import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_screen_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class RegenerativeGameDetails extends StatefulWidget {
  final void Function()? onArrowTap;
  final bool isVisible;

  const RegenerativeGameDetails({
    Key? key,
    required this.onArrowTap,
    required this.isVisible,
  }) : super(key: key);

  @override
  State<RegenerativeGameDetails> createState() =>
      _RegenerativeGameDetailsState();
}

class _RegenerativeGameDetailsState extends State<RegenerativeGameDetails> {
  @override
  Widget build(BuildContext context) {
    AuthStore authStore = Provider.of<AuthStore>(context);
    ProfileScreenStore profileStore = Provider.of<ProfileScreenStore>(context);
    return Container(
      height: 46,
      decoration: BoxDecoration(
          border: Border.fromBorderSide(
              BorderSide(width: 1, color: Color(0xff101010).withOpacity(.1))),
          borderRadius: BorderRadius.circular(45)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  barrierColor: Colors.black.withAlpha(1),
                  backgroundColor: Colors.black.withAlpha(1),
                  builder: (BuildContext context) {
                    return SnackBarWidget(
                      menu: AppLocalizations.of(context)!.regenerationGame,
                      text: AppLocalizations.of(context)!.theRegenerationGame,
                      buttons: [
                        ButtonSnackBar(
                          text: AppLocalizations.of(context)!.learnMore,
                          onTapAbout: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              PageRoute.Page.homeScreen.route,
                              (Route<dynamic> route) => false,
                              arguments: {
                                "returnToPageWithArgs": {
                                  'currentPageName': "learning_tracks"
                                }
                              },
                            );
                          },
                        )
                      ],
                      marginBottom: true,
                    );
                  },
                );
              },
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: AppLocalizations.of(context)!.personalGoal + ": ",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  TextSpan(
                    text:
                        "${authStore.currentUser?.dailyLearningGoalInMinutes ?? 00}min",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text("|",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              width: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      barrierColor: Colors.black.withAlpha(1),
                      backgroundColor: Colors.black.withAlpha(1),
                      builder: (BuildContext context) {
                        return SnackBarWidget(
                            menu: AppLocalizations.of(context)!.laurelWreath,
                            text: AppLocalizations.of(context)!
                                .laurelWreathRepresentHowManyTimesAPersonHasReachedTheirGoalInTheRegenerationGame,
                            buttons: [
                              ButtonSnackBar(
                                text: AppLocalizations.of(context)!.learnMore,
                                onTapAbout: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    PageRoute.Page.homeScreen.route,
                                    (Route<dynamic> route) => false,
                                    arguments: {
                                      "returnToPageWithArgs": {
                                        'currentPageName': "learning_tracks"
                                      }
                                    },
                                  );
                                },
                              )
                            ],
                            marginBottom: true);
                      },
                    );
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons_profile/laurel_wreath.svg",
                        width: 24,
                        height: 21,
                        color: Color(0xff018f9c),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("${profileStore.profile!.totalTrophyQuantity!}",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff018f9c),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: widget.onArrowTap,
                  child: RotationTransition(
                    turns: !widget.isVisible
                        ? AlwaysStoppedAnimation(270 / 360)
                        : AlwaysStoppedAnimation(90 / 360),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Color(0xff03145C),
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
