import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ootopia_app/data/models/friends/friend_model.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/screens/friends/add_friends/add_friends.dart';
import 'package:ootopia_app/screens/friends/circle_friends_page/item_friend.dart';
import 'package:ootopia_app/screens/friends/friends_store.dart';
import 'package:ootopia_app/screens/friends/shimmer/list_items_shimmer.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

import 'circle_friends_store.dart';

class CircleOfFriendPage extends StatefulWidget {
  final String userId;
  final bool? displayContacts;

  CircleOfFriendPage({Key? key, required this.userId, this.displayContacts})
      : super(key: key);

  @override
  State<CircleOfFriendPage> createState() => _CircleOfFriendPageState();
}

class _CircleOfFriendPageState extends State<CircleOfFriendPage> {
  late AuthStore authStore;
  CircleFriendsStore circleFriendsStore = CircleFriendsStore();
  late FriendsStore friendsStore;
  SmartPageController controller = SmartPageController.getInstance();
  List<String> orderBy = [];
  bool isPageOfUserLogged = false;
  String orderBySelected = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    Future.delayed(Duration.zero, () {
      if (orderBy.isEmpty) {
        orderBy = [
          AppLocalizations.of(context)!.alphabeticalOrder,
          AppLocalizations.of(context)!.mostRecent,
          AppLocalizations.of(context)!.older,
        ];
        orderBySelected = orderBy[0];
      }
      isPageOfUserLogged =  getIfIsPageOfUserLogged();

      if (isPageOfUserLogged) {
        friendsStore.init(widget.userId);
      } else {
        circleFriendsStore.init(widget.userId, authStore.currentUser != null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);
    friendsStore = Provider.of<FriendsStore>(context);
    var observer = Stack(
      children: [
        BackgroundButterflyTop(positioned: -59),
        BackgroundButterflyBottom(positioned: -50),
        if (isPageOfUserLogged) ...[
          Consumer<FriendsStore>(builder: (cont, friend, child) {
            return body();
          })
        ] else ...[
          Observer(builder: (_) {
            return body();
          })
        ]
      ],
    );
    if (widget.displayContacts != null) {
      return Scaffold(
        appBar: appBarProfile,
        body: observer,
      );
    }
    return observer;
  }

  get appBarProfile => DefaultAppBar(
    components: [
      AppBarComponents.back,
      AppBarComponents.empty,
    ],
    onTapLeading: () => Navigator.pop(context),
  );

  Widget body() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (loadMoreFriends(scrollInfo)) {
          Future.delayed(Duration.zero, () async {
            if (isPageOfUserLogged) {
              await friendsStore.getMoreFriends(widget.userId);
            } else {
              await circleFriendsStore.getMoreFriends(widget.userId);
              setState(() {});
            }
          });
        }
        return true;
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 14.0, left: 28, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.friends,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: circleFriendsStore.isLoading ||
                            friendsStore.isLoadingGetAllFriends
                            ? Shimmer.fromColors(
                          baseColor: Colors.grey[300] ?? Colors.blue,
                          highlightColor: Colors.grey[100] ?? Colors.blue,
                          child: Container(
                            height: 10,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        )
                            : Text(
                          "${getAmountOfFriends()}"
                              " ${AppLocalizations.of(context)!.friends}",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                            color: Color(0xff939598),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isPageOfUserLogged) ...[
                    ElevatedButton(
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                              Size(double.infinity, 35)),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide.none),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              LightColors.blue),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 24)),
                        ),
                        onPressed: () {
                          Future.delayed(Duration(milliseconds: 100), () {
                            controller.insertPage(AddFriends());
                          });
                        },
                        child: Text(
                          MediaQuery.of(context).size.width <= 300
                              ? AppLocalizations.of(context)!.add
                              : AppLocalizations.of(context)!.addFriend,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                  ]
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                _showDialog(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 25, top: 18),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/list.png',
                      height: 10,
                    ),
                    SizedBox(width: 6),
                    RichText(
                      text: TextSpan(
                        text: AppLocalizations.of(context)!.orderBy,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: " $orderBySelected",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (circleFriendsStore.isLoading ||
                friendsStore.isLoadingGetAllFriends) ...[
              ListItemsShimmer(),
            ] else if (isPageOfUserLogged && allFriendsIsHide()) ...[
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(30, 48, 30, 8),
                child: Text(
                  AppLocalizations.of(context)!.youDontHaveAnyFriends,
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
                  AppLocalizations.of(context)!.youDontHaveAnyFriendsSubtext,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: LightColors.grey.withOpacity(0.7),
                  ),
                ),
              ),
            ] else ...[
              Container(
                margin: EdgeInsets.only(top: 4),
                height: MediaQuery.of(context).size.height - 220,
                child: ListView.builder(
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    itemCount: amountOfFriends(),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                bottom:
                                (index == amountOfFriends() - 1) ? 80 : 0),
                            child: ItemFriend(
                              friendModel: getFriendModel(index),
                              controller: controller,
                              displayContacts: widget.displayContacts,
                              currentUserid: authStore.currentUser?.id,
                              isPageOfUserLogged: isPageOfUserLogged,
                              friendsStore: friendsStore,
                            ),
                          ),
                          Visibility(
                              visible: (friendsStore.loadingMoreFriends ||
                                  circleFriendsStore.loadingMoreFriends) &&
                                  (index == amountOfFriends() - 1),
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
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
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget rankedItemSelect(int index, context) {
    return Material(
      color: orderBySelected == orderBy[index]
          ? LightColors.blue.withOpacity(0.18)
          : LightColors.white,
      child: Ink(
        child: InkWell(
          splashColor: LightColors.blue,
          onTap: () {
            Future.delayed(Duration(milliseconds: 100), () {
              setState(() {
                orderBySelected = orderBy[index];
              });
              if (isPageOfUserLogged) {
                friendsStore.changeOrderBy(index);
                Navigator.of(context).pop();
                friendsStore.getFriends(widget.userId);
              } else {
                circleFriendsStore.changeOrderBy(index);
                Navigator.of(context).pop();
                circleFriendsStore.getFriends(widget.userId);
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  orderBy[index],
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              height: 185,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 14, left: 24, bottom: 12),
                    child: Text(
                      AppLocalizations.of(context)!.orderBy,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  rankedItemSelect(0, context),
                  rankedItemSelect(1, context),
                  rankedItemSelect(2, context),
                ],
              ),
            ));
      },
    );
  }

  bool getIfIsPageOfUserLogged() {
    return widget.userId == authStore.currentUser?.id;
  }

  bool allFriendsIsHide() {
    if (isPageOfUserLogged) {
      bool allFriendsIsHide = true;
      friendsStore.friendsDate.friends!.forEach((element) {
        if (element?.remove != true) {
          allFriendsIsHide = false;
        }
      });
      return allFriendsIsHide;
    }
    return false;
  }

  String getAmountOfFriends() {
    if (isPageOfUserLogged) {
      return '${friendsStore.friendsDate.total ?? 0}';
    } else {
      return '${circleFriendsStore.friendsDate.total ?? 0}';
    }
  }

  bool loadMoreFriends(ScrollNotification scrollInfo) {
    late bool status;
    if (isPageOfUserLogged) {
      status = !friendsStore.loadingMoreFriends && friendsStore.hasMoreFriends;
    } else {
      status = !circleFriendsStore.loadingMoreFriends &&
          circleFriendsStore.hasMoreFriends;
    }
    return status &&
        scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent * 0.6;
  }

  int amountOfFriends() {
    if (isPageOfUserLogged) {
      return friendsStore.friendsDate.friends?.length ?? 0;
    } else {
      return circleFriendsStore.friendsDate.friends?.length ?? 0;
    }
  }

  FriendModel getFriendModel(index) {
    return isPageOfUserLogged
        ? friendsStore.friendsDate.friends![index]!
        : circleFriendsStore
        .friendsDate.friends![index]!;
  }
}
