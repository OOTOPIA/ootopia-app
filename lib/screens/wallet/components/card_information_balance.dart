import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/screens/marketplace/components/get_adaptive_size.dart';
import 'package:ootopia_app/screens/marketplace/transfer_success_screen.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/shared/snackbar_component.dart';

class CardInformationBalance extends StatelessWidget {
  final String iconForeground;
  final String iconBackground;
  final String balanceOfTransactions;
  final String originTransaction;
  final String toOrFrom;
  final String action;
  final String? otherUserId;
  final String? postId;
  final String? description;
  final String? origin;

  CardInformationBalance(
      {required this.balanceOfTransactions,
      required this.iconForeground,
      required this.iconBackground,
      required this.toOrFrom,
      required this.originTransaction,
      required this.action,
      this.otherUserId,
      this.postId,
      this.description,
      this.origin});

  String getTransactionDescription(context) {
    String text = '';

    switch (originTransaction) {
      case 'total_game_completed':
        text = AppLocalizations.of(context)!.totalGameCompleted;
        break;
      case 'personal_goal_achieved':
        text = AppLocalizations.of(context)!.personalGoalAchieved;
        break;
      case 'gratitude_reward':
        text = AppLocalizations.of(context)!.gratitudeReward;
        break;
      case 'invitation_code':
        text = AppLocalizations.of(context)!.invitationCode;
        break;
      case 'invitation_code_sent':
        text = AppLocalizations.of(context)!.invitationCodeSent;
        break;
      case 'invitation_code_accepted':
        text = AppLocalizations.of(context)!.invitationCodeAccepted;
        break;
      case 'market_place_transfer':
        text = this.description ?? "";
        break;
      case 'learning_track':
        text = this.description ?? "";
        break;
    }

    return text;
  }

  String getTransactionTitle(context) {
    String text = '';

    switch (originTransaction) {
      case 'total_game_completed':
        text = AppLocalizations.of(context)!.regenerationGame;
        break;
      case 'personal_goal_achieved':
        text = AppLocalizations.of(context)!.regenerationGame;
        break;
      case 'gratitude_reward':
        text = AppLocalizations.of(context)!.gratitudeReward;
        break;
      case 'invitation_code':
        text = AppLocalizations.of(context)!.invitationCode;
        break;
      case 'invitation_code_sent':
        text = AppLocalizations.of(context)!.invitationCodeSent;
        break;
      case 'invitation_code_accepted':
        text = AppLocalizations.of(context)!.invitationCodeAccepted;
        break;
      case 'market_place_transfer':
        text = AppLocalizations.of(context)!.marketPlaceTransfer;
        break;
      case 'learning_track':
        text = AppLocalizations.of(context)!.learningTracks;
        break;
    }

    return text;
  }

  int colorOfBalance = 0xff003694;
  String typeActionFromOrTo = '';

  @override
  Widget build(BuildContext context) {
    switch (action) {
      case 'received':
        colorOfBalance = 0xff018F9C;
        typeActionFromOrTo = AppLocalizations.of(context)!.from;
        break;
      case 'sent':
        if (this.originTransaction != "invitation_code_sent") {
          colorOfBalance = 0xff000000;
        } else {
          colorOfBalance = 0xff018F9C;
        }
        typeActionFromOrTo = AppLocalizations.of(context)!.to;
        break;
      default:
    }

    void _goToProfile() async {
      Navigator.of(context).pushNamed(
        PageRoute.Page.profileScreen.route,
        arguments: {
          "id": this.otherUserId,
        },
      );
    }

    var iconBackground = this.iconBackground.contains('.svg')
        ? SvgPicture.network(
            this.iconBackground,
            width: getAdaptiveSize(52, context),
            height: getAdaptiveSize(52, context),
            fit: BoxFit.cover,
          )
        : Image.network(this.iconBackground,
            height: getAdaptiveSize(52, context),
            width: getAdaptiveSize(52, context),
            fit: BoxFit.cover);

    var iconForeground;

    if (this.originTransaction.isNotEmpty &&
        this.originTransaction == "gratitude_reward") {
      if (this.iconForeground.isNotEmpty) {
        iconForeground = Image.network(this.iconForeground, fit: BoxFit.cover);
      } else {
        iconForeground = Image.asset(
            "assets/icons/user_without_image_profile.png",
            fit: BoxFit.cover);
      }
    } else {
      iconForeground = SvgPicture.asset(
          "assets/icons/ooz_circle_icon_active.svg",
          fit: BoxFit.cover);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: getAdaptiveSize(56, context),
              child: Stack(children: [
                GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: iconBackground,
                  ),
                  onTap: () {
                    if (this.otherUserId != null) {
                      if (this.originTransaction == 'gratitude_reward') {
                        Navigator.of(context).pushNamed(
                          PageRoute.Page.timelineProfileScreen.route,
                          arguments: {
                            "userId": this.otherUserId,
                            "postId": this.postId,
                            "postSelected": 0,
                          },
                        );
                      } else if (this.originTransaction ==
                              "total_game_completed" ||
                          this.originTransaction == "personal_goal_achieved") {
                        showModalBottomSheet(
                            barrierColor: Colors.black.withAlpha(1),
                            context: context,
                            backgroundColor: Colors.black.withAlpha(1),
                            builder: (BuildContext context) {
                              return SnackBarWidget(
                                menu: AppLocalizations.of(context)!
                                    .regenerationGame,
                                text: AppLocalizations.of(context)!
                                    .aboutRegenerationGame,
                                about: AppLocalizations.of(context)!.learnMore,
                                marginBottom: true,
                              );
                            });
                      } else if (this.origin == "market_place_transfer") {
                        showDialog(
                            context: context,
                            builder: (context) => TransferSuccessScreen(
                                  goToMarketPlacePage: false,
                                ));
                      }
                    }
                  },
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: getAdaptiveSize(30, context),
                    height: getAdaptiveSize(30, context),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: Colors.white)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: GestureDetector(
                          child: iconForeground,
                          onTap: () {
                            if (this.originTransaction == 'gratitude_reward') {
                              _goToProfile();
                            }
                          }),
                    ),
                  ),
                ),
              ]),
            ),
            Container(
              // text and sent
              margin: EdgeInsets.only(left: getAdaptiveSize(16, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width < 400
                        ? MediaQuery.of(context).size.width * 0.3
                        : MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      getTransactionTitle(context),
                      style: TextStyle(
                          color: Color(0xff018F9C),
                          fontWeight: FontWeight.bold,
                          fontSize: getAdaptiveSize(12, context)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (this.originTransaction != "gratitude_reward")
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: getAdaptiveSize(4, context), horizontal: 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width < 400
                            ? MediaQuery.of(context).size.width * 0.3
                            : MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                          getTransactionDescription(context),
                          style: TextStyle(
                            color: Color(0xff707070),
                            fontWeight: FontWeight.w400,
                            fontSize: getAdaptiveSize(14, context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: '$typeActionFromOrTo',
                        style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: getAdaptiveSize(12, context))),
                    TextSpan(
                        text:
                            ' ${this.toOrFrom.isEmpty ? "Ootopia" : this.toOrFrom}',
                        style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: getAdaptiveSize(12, context),
                            fontWeight: FontWeight.bold),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            if (this.toOrFrom.isNotEmpty) {
                              _goToProfile();
                            }
                          }),
                  ]))
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          // wallet Ozz
          width: getAdaptiveSize(80, context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                'assets/icons/ooz-coin-blue-small.svg',
                color: Color(colorOfBalance),
                height: getAdaptiveSize(10, context),
              ),
              Text(
                '${this.action == "sent" && this.originTransaction != "invitation_code_sent" ? '-' : ''} ${this.balanceOfTransactions.length > 6 ? NumberFormat.compact().format(double.parse(this.balanceOfTransactions)).replaceAll('.', ',') : this.balanceOfTransactions.replaceAll('.', ',')}',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(colorOfBalance),
                    fontSize: getAdaptiveSize(14, context)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
