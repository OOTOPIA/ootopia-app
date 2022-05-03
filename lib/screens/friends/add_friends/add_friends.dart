import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/data/models/friends/friend_model.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/screens/friends/friends_store.dart';
import 'package:ootopia_app/screens/friends/get_contacts.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

import '../../auth/auth_store.dart';

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
                        friendsStore.searchNewName(messageController.text);
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white.withOpacity(0.3),
                        prefixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            friendsStore.searchNewName(messageController.text);
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
                if (!widget.displayContacts && !widget.displayModal)
                  Visibility(
                    visible: !friendsStore.isLoading &&
                        !(friendsStore.usersSearch.friends?.isEmpty ?? true),
                    child: Container(
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
                  ),
                if (friendsStore.isLoadingSearch) ...[
                  SizedBox(
                    height: 6,
                  ),
                  ListView.builder(
                      itemCount: 11,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return itemShimmer();
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
                        itemCount: friendsStore.usersSearch.friends!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      bottom: isLastItem(index) ? 100 : 0),
                                  child: itemFriend(friendsStore
                                      .usersSearch.friends![index]!)),
                              Visibility(
                                  visible:
                                      friendsStore.loadingMoreUsersSearch &&
                                          isLastItem(index),
                                  child: Container(
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
                                  )),
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

  Widget itemShimmer() {
    double size = MediaQuery.of(context).size.width - (25 + 14 + 48 + 82);
    return Shimmer.fromColors(
      baseColor: Colors.grey[300] ?? Colors.blue,
      highlightColor: Colors.grey[100] ?? Colors.blue,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(25, 16, 25, 0),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 11,
                        width: size * 0.35,
                        color: Colors.white,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 6),
                        height: 8,
                        width: size * 0.23,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  height: 24,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ],
            ),
          ),
          Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(
                      left: index == 0 ? 25 : 8,
                      top: 14,
                      right: index == 4 ? 14 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    height: 76,
                    width: 74,
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget itemFriend(FriendModel friendModel) {
    return Consumer<FriendsStore>(builder: (cont, counter, _) {
      return Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Material(
            color: Colors.transparent,
            child: Ink(
              child: InkWell(
                splashColor: LightColors.grey.withOpacity(0.2),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(25, 4, 25, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300] ?? Colors.blue,
                            highlightColor: Colors.grey[100] ?? Colors.blue,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                friendModel.photoUrl ?? '',
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                                errorBuilder: (context, url, error) =>
                                    Image.asset(
                                  'assets/icons/user.png',
                                  fit: BoxFit.cover,
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12),
                        width: MediaQuery.of(context).size.width - 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              friendModel.fullname ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: LightColors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              friendModel.location(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: LightColors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 24,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(
                                  Size(double.infinity, 10)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide.none),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  LightColors.blue),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.symmetric(horizontal: 18)),
                            ),
                            onPressed: () {
                              Future.delayed(Duration(milliseconds: 80), () {
                                if (friendModel.isFriend != true) {
                                  friendModel.isFriend = true;

                                  friendsStore.addFriend(friendModel);
                                  setState(() {});
                                } else {
                                  friendsStore.removeFriend(
                                      friendModel, authStore.currentUser!.id);
                                  friendModel.isFriend = false;
                                }
                              });
                            },
                            child: Text(
                              getIfIsFriend(friendModel)
                                  ? AppLocalizations.of(context)!.friend
                                  : AppLocalizations.of(context)!.add,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Future.delayed(Duration(milliseconds: 100), () {
                    _goToProfile(friendModel.id);
                  });
                },
              ),
            ),
          ),
          if (friendModel.friendsThumbs?.isNotEmpty ?? false) ...[
            SizedBox(
              height: 8,
            ),
            Container(
              height: 76,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  itemCount: friendModel.amountOfPhotos(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300] ?? Colors.blue,
                          highlightColor: Colors.grey[100] ?? Colors.blue,
                          child: Container(
                            margin: EdgeInsets.only(
                              left: index == 0 ? 25 : 8,
                              top: 2,
                              right: index == friendModel.friendsThumbs!.length
                                  ? 14
                                  : 0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            height: 76,
                            width: 74,
                          ),
                        ),
                        Container(
                          width: 74,
                          height: 76,
                          margin: EdgeInsets.only(
                            left: index == 0 ? 25 : 8,
                            right:
                                index == (friendModel.friendsThumbs!.length - 1)
                                    ? 14
                                    : 0,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              friendModel.friendsThumbs![index]!.thumbnailUrl ??
                                  '',
                              fit: BoxFit.cover,
                              width: 74,
                              height: 76,
                              errorBuilder: (context, url, error) => Container(
                                width: 74,
                                height: 76,
                                color: Colors.grey,
                                child: Center(
                                  child: Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (friendModel.friendsThumbs![index]!.type ==
                            'video') ...[
                          Container(
                            width: 74,
                            height: 76,
                            margin: EdgeInsets.only(
                              left: index == 0 ? 25 : 8,
                              right: index ==
                                      (friendModel.friendsThumbs!.length - 1)
                                  ? 14
                                  : 0,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: Ink(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 25 : 8,
                              right: index == (friendModel.amountOfPhotos() - 1)
                                  ? 14
                                  : 0,
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Future.delayed(Duration(milliseconds: 80), () {
                                  _goToProfile(friendModel.id);
                                });
                              },
                              child: SizedBox(
                                width: 74,
                                height: 76,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            )
          ]
        ],
      );
    });
  }

  void _goToProfile(userId) async {
    if (widget.displayContacts) {
      Navigator.of(context).pushNamed(
        PageRoute.Page.profileScreen.route,
        arguments: {
          "id": userId,
          "isGetContacts": true,
        },
      );
    } else {
      controller.insertPage(ProfileScreen(
        {
          "id": userId,
        },
      ));
    }
  }

  getIfIsFriend(FriendModel friendModel) {
    if (friendModel.isFriend == true) {
      return true;
    }
    bool isFriend = false;
    friendsStore.myFriendsDate.friends?.forEach((element) {
      if (element!.id == friendModel.id) {
        isFriend = true;
      }
    });
    return isFriend;
  }

  bool isLastItem(int index) {
    return (index == friendsStore.usersSearch.friends!.length - 1);
  }
}
