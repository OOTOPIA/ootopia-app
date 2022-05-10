import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/screens/friends/add_friends/add_friends.dart';
import 'package:ootopia_app/screens/friends/friends_store.dart';
import 'package:ootopia_app/screens/friends/suggestion_friends/item_friend_component.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:provider/provider.dart';

class SuggestionFriends extends StatefulWidget {
  final String userId;
  final FriendsStore friendsStore;
  const SuggestionFriends({
    Key? key,
    required this.userId,
    required this.friendsStore,
  }) : super(key: key);

  @override
  State<SuggestionFriends> createState() => _SuggestionFriendsState();
}

class _SuggestionFriendsState extends State<SuggestionFriends> {
  SmartPageController controller = SmartPageController.getInstance();
  @override
  void initState() {
    super.initState();
    widget.friendsStore.sendContactsToApiProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FriendsStore>(builder: (context, friendsStore, _) {
      return Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      GlobalConstants.of(context).screenHorizontalSpace),
              child: Divider(
                height: 1,
                color: Color(0xff707070).withOpacity(.5),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16, left: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: SvgPicture.asset(
                            'assets/icons/suggestion-friend.svg'),
                      ),
                      SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: AppLocalizations.of(context)!
                                  .friendSuggestions,
                              style: TextStyle(
                                fontSize: 16,
                                color: LightColors.grey,
                                fontWeight: FontWeight.w400,
                              )),
                        ])),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Future.delayed(Duration(milliseconds: 100), () {
                        controller.insertPage(AddFriends(
                          displayModal: true,
                        ));
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.seeAll,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: LightColors.blue,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: LightColors.blue,
                          size: 14,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  buttonToSuggestionFriends(),
                  Row(
                    children: widget.friendsStore.suggestionFriends.friends!
                        .map((e) => ItemFriend(
                              friend: e!,
                              friendsStore: widget.friendsStore,
                            ))
                        .toList(),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  Widget buttonToSuggestionFriends() {
    return GestureDetector(
      onTap: () {
        Future.delayed(Duration(milliseconds: 100), () {
          controller.insertPage(AddFriends(
            displayModal: true,
          ));
        });
      },
      child: Container(
        width: 100,
        height: 150,
        decoration: BoxDecoration(
          color: LightColors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        margin: EdgeInsets.only(left: 24, right: 8),
        padding: EdgeInsets.only(top: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              child: CircleAvatar(
                backgroundColor: Color(0xFFd4d4d4),
                child: Icon(
                  Icons.search,
                  color: Color(0xff707070),
                  size: 30,
                ),
              ),
              padding: EdgeInsets.all(0.0),
            ),
            Container(
              margin: EdgeInsets.only(top: 2),
              child: Text(
                AppLocalizations.of(context)!.search,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 9,
                    color: Color(0xff707070)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
