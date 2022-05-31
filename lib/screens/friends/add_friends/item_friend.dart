import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/friends/friend_model.dart';
import 'package:ootopia_app/screens/friends/friends_store.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';


class ItemFriend extends StatelessWidget {
  final FriendsStore friendsStore;
  final FriendModel friendModel;
  final bool displayContacts;
  final SmartPageController controller;
  final String currentUserId;

  const ItemFriend({Key? key,
    required this.currentUserId,
    required this.friendsStore,
    required this.friendModel,
    required this.displayContacts,
    required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Consumer<FriendsStore>(builder: (cont, counter, _) {
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
                            errorBuilder: (context, url, error) => Image.asset(
                                  'assets/icons/user.png',
                                  fit: BoxFit.cover,
                                  width: 40,
                                  height: 40,
                                ),
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300] ?? Colors.blue,
                                highlightColor: Colors.grey[100] ?? Colors.blue,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white, shape: BoxShape.circle),
                                ),
                              );
                            },
                          ),
                        ),
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
                                  ///setState(() {});
                                } else {
                                  friendsStore.removeFriend(
                                      friendModel, currentUserId);
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
                    _goToProfile(friendModel.id, context);
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
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300] ?? Colors.blue,
                                  highlightColor: Colors.grey[100] ?? Colors.blue,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    height: 76,
                                    width: 74,
                                  ),
                                );
                              },
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
                                  _goToProfile(friendModel.id, context);
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

  bool getIfIsFriend(FriendModel friendModel) {
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

  void _goToProfile(userId, context) async {
    if (displayContacts) {
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


}
