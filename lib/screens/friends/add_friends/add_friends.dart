import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/screens/friends/friends_store.dart';
import 'package:ootopia_app/screens/friends/get_contacts.dart';
import 'package:ootopia_app/screens/friends/shimmer/item_shimmer.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

import '../../auth/auth_store.dart';
import 'item_friend.dart';

class AddFriends extends StatefulWidget {
  final bool displayContacts;
  final dynamic arguments;
  final bool displayModal;
  AddFriends({
    this.displayContacts = false,
    this.displayModal = false,
    this.arguments,
  });
  @override
  State<AddFriends> createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  late AuthStore authStore;
  TextEditingController messageController = TextEditingController();
  SmartPageController controller = SmartPageController.getInstance();
  late FriendsStore friendsStore;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      friendsStore.cleanSearchPage();
      if (widget.displayContacts || widget.displayModal) {
        askPermissions(context, friendsStore, widget.displayModal);
        await authStore.checkUserIsLogged();
      }
    });
  }

  void redirectToHomePage() async {
    if (widget.arguments['goal'] != null &&
        widget.arguments['goal'] == 'invitationCode') {
      Navigator.of(context).pushNamedAndRemoveUntil(
        PageRoute.Page.celebration.route,
        (Route<dynamic> route) => false,
        arguments: widget.arguments,
      );
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
        PageRoute.Page.homeScreen.route,
        (Route<dynamic> route) => false,
        arguments: widget.arguments,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    friendsStore = Provider.of<FriendsStore>(context);
    authStore = Provider.of<AuthStore>(context);
    return Consumer<FriendsStore>(builder: (cont, counter, _) {
      if (widget.displayContacts) {
        return Scaffold(
          appBar: defaultAppBar,
          body: body(context),
        );
      }
      return body(context);
    });
  }

  get defaultAppBar => DefaultAppBar(
        components: [
          AppBarComponents.keep,
        ],
        onTapAction: redirectToHomePage,
      );

  Widget body(BuildContext context) {
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
              if (widget.displayContacts) {
                friendsStore.getMoreUserByContact();
              } else if (widget.displayModal) {
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
                if (showAmountOfFriends())...[
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
                  ListView.builder(
                      itemCount: 11,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ItemShimmer();
                      }),
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
                  if (widget.displayContacts)
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                    ),
                ] else ...[
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    height: widget.displayContacts
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
                                      displayContacts: widget.displayContacts,
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

  bool showAmountOfFriends() {
    return !widget.displayContacts &&
        !widget.displayModal &&
        (friendsStore.usersSearch.total != null) &&
        !friendsStore.isLoading &&
        !(friendsStore.usersSearch.friends?.isEmpty ?? true);
  }
}
