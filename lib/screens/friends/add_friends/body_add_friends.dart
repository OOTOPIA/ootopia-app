import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/screens/friends/friends_store.dart';
import 'package:ootopia_app/screens/friends/shimmer/list_items_shimmer.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

import 'item_friend.dart';
class BodyAddFriends extends StatelessWidget {
  final FriendsStore friendsStore;
  final SmartPageController controller;
  final authStore;
  final bool displayModal;
  final bool displayContacts;
  final bool showAmountOfFriends;
  final TextEditingController messageController;


  const BodyAddFriends({Key? key,
    required this.friendsStore,
    required this.controller,
    required this.authStore,
    required this.displayModal,
    required this.messageController,
    required this.displayContacts,
    required this.showAmountOfFriends}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundButterflyTop(positioned: -59),
        BackgroundButterflyBottom(positioned: -50),
        NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!friendsStore.loadingMoreUsersSearch &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent * 0.6 &&
                friendsStore.hasMoreUsersSearch) {
              if (displayContacts) {
                friendsStore.getMoreUserByContact();
              } else if (displayModal) {
                friendsStore.getMoreUserByContactProfile();
              } else {
                friendsStore.getMoreUserBySearch();
              }
            }
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 14.0, left: 28),
                  child: Text(
                    AppLocalizations.of(context)!.addFriends,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 21,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, left: 28),
                  child: Text(
                    AppLocalizations.of(context)!.searchFriendsMsg,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 12, 25, 0),
                  child: Container(
                    height: 42,
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          friendsStore.cleanSearchPage();
                        }
                      },
                      textCapitalization: TextCapitalization.words,
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.search,
                      style: GoogleFonts.roboto(
                          fontSize: 14, fontWeight: FontWeight.normal),
                      onEditingComplete: () {
                        if (friendsStore.isLoadingSearch == false) {
                          friendsStore.searchNewName(messageController.text);
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white.withOpacity(0.3),
                        prefixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if (friendsStore.isLoadingSearch == false) {
                              friendsStore
                                  .searchNewName(messageController.text);
                            }
                          },
                          icon: Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            child: SvgPicture.asset(
                              'assets/icons/search.svg',
                              color: LightColors.blue,
                            ),
                          ),
                        ),
                        contentPadding: EdgeInsets.only(top: 16, right: 16),
                        hintText: AppLocalizations.of(context)!.searchFriends,
                        hintStyle: GoogleFonts.roboto(
                            fontSize: 16,
                            color: LightColors.grey,
                            fontWeight: FontWeight.w400),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide:
                            BorderSide(width: 1, color: LightColors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide:
                            BorderSide(width: 1, color: LightColors.grey)),
                      ),
                    ),
                  ),
                ),
                if (showAmountOfFriends)...[
                  Container(
                    margin: EdgeInsets.only(left: 25, top: 8),
                    child: Text(
                      '${friendsStore.usersSearch.total} '
                          '${AppLocalizations.of(context)!.resultsFor} '
                          '\"${friendsStore.lastName}\"',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 12,
                          color: LightColors.blue,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
                if (friendsStore.isLoadingSearch) ...[
                  SizedBox(
                    height: 6,
                  ),
                  ListItemsShimmer(),
                ] else if (friendsStore.searchIsEmpty) ...[
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(30, 48, 30, 8),
                    child: Text(
                      AppLocalizations.of(context)!.userNotFound,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: LightColors.grey,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(48, 0, 48, 15),
                    child: Text(
                      AppLocalizations.of(context)!.userNotFoundMsg,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: LightColors.grey.withOpacity(0.7),
                      ),
                    ),
                  ),
                  if (displayContacts)
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                    ),
                ] else ...[
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    height: displayContacts
                        ? MediaQuery.of(context).size.height - 100
                        : MediaQuery.of(context).size.height - 250,
                    child: ListView.builder(
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                        itemCount: friendsStore.usersSearch.friends!.length,
                        itemBuilder: (BuildContext context, int index) {
                          bool lastItem = isLastItem(index);
                          return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: lastItem ? 100 : 0),
                                child: ItemFriend(
                                    currentUserId: authStore.currentUser!.id!,
                                    friendsStore: friendsStore,
                                    controller: controller,
                                    displayContacts: displayContacts,
                                    friendModel: friendsStore.usersSearch.friends![index]!),
                              ),
                              if(friendsStore.loadingMoreUsersSearch && lastItem)...[
                                Container(
                                  margin: EdgeInsets.only(top: 16),
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.transparent,
                                        strokeWidth: 2,
                                        valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                            LightColors.blue),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ],
                          );
                        }),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }


  bool isLastItem(int index) {
    return (index == friendsStore.usersSearch.friends!.length - 1);
  }
}
