import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/data/models/friends/friend_model.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/friends/friends_store.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class ItemFriendsWidget extends StatefulWidget {
  final FriendModel friendModel;
  final bool isPageOfUserLogged;
  ItemFriendsWidget(  this.friendModel, this.isPageOfUserLogged, {Key? key}) : super(key: key);

  @override
  _ItemFriendsWidgetState createState() => _ItemFriendsWidgetState();
}

class _ItemFriendsWidgetState extends State<ItemFriendsWidget> {
  SmartPageController controller = SmartPageController.getInstance();
  late FriendsStore friendsStore;
  late AuthStore authStore;


  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);
    friendsStore  = Provider.of<FriendsStore>(context);
    return  itemFriend( widget.friendModel);
  }

  Widget itemFriend(FriendModel friendModel){
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: friendModel.remove == true ? 0 : hasImages(friendModel) ? 150: 66,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 18,
            ),
            Material(
              color: Colors.transparent,
              child: Ink(
                child: InkWell(
                  splashColor: LightColors.grey.withOpacity(0.2),
                  child:  Padding(
                    padding: EdgeInsets.fromLTRB(25, 4, 14, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Shimmer.fromColors(
                              baseColor:  Colors.grey[300] ?? Colors.blue,
                              highlightColor:  Colors.grey[100] ?? Colors.blue,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle
                                ),
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
                                  errorBuilder: (context, url, error) => Image.asset(
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

                        if(widget.isPageOfUserLogged)...[
                          SizedBox(
                            height: 24,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all<double>(0.0),                              fixedSize: MaterialStateProperty.all<Size>(Size(double.infinity, 24)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular
                                        (20),
                                      side: BorderSide(
                                          color: LightColors.blue),
                                      //borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>
                                    (Colors.transparent),
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                      EdgeInsets.symmetric(horizontal: 14)),
                                ),
                                onPressed: () {
                                  Future.delayed(Duration(milliseconds: 100),(){
                                    friendsStore.removeFriend(friendModel, authStore.currentUser!.id);
                                  });
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.remove,
                                  style: TextStyle(
                                    color: LightColors.blue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          )
                        ]else if(!widget.isPageOfUserLogged && friendModel.isFriend != null &&
                            (friendModel.id != authStore.currentUser?.id)
                        )...[
                            SizedBox(
                              height: 24,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all<double>(0.0),                              fixedSize: MaterialStateProperty.all<Size>(Size(double.infinity, 24)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular
                                          (20),
                                        side: BorderSide(
                                            color: LightColors.blue),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all<Color>
                                      (friendModel.isFriend == true ?
                                    Colors.transparent : LightColors.blue),
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.symmetric(horizontal: 14)),
                                  ),
                                  onPressed: () {
                                    Future.delayed(Duration(milliseconds: 100),(){
                                      if(friendModel.isFriend == true){
                                        friendsStore.removeFriend(friendModel, authStore.currentUser!.id);
                                      }else{
                                        friendsStore.addFriend(friendModel);
                                      }
                                      friendModel.isFriend = !friendModel.isFriend!;
                                      setState(() {});
                                    });
                                  },
                                  child: Text(friendModel.isFriend == true ?
                                  AppLocalizations.of(context)!.remove :
                                  AppLocalizations.of(context)!.add ,
                                    style: TextStyle(
                                      color: friendModel.isFriend == true ?
                                      LightColors.blue : LightColors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            )
                          ],



                      ],
                    ),
                  ),
                  onTap: () {
                    Future.delayed(Duration(milliseconds: 100),(){
                      _goToProfile(friendModel.id);
                    });
                  },
                ),
              ),
            ),
            if(friendModel.friendsThumbs?.isNotEmpty ?? false)...[
              SizedBox(
                height: 8,
              ),
              Container(
                height: 76,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: friendModel.friendsThumbs!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return  Stack(
                        children: [
                          Shimmer.fromColors(
                            baseColor:  Colors.grey[300] ?? Colors.blue,
                            highlightColor:  Colors.grey[100] ?? Colors.blue,
                            child: Container(
                              margin: EdgeInsets.only(
                                left: index == 0 ? 25 : 8,
                                top: 2,
                                right: index == (friendModel.friendsThumbs!
                                    .length - 1) ? 14 : 0,
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
                              right: index == friendModel.friendsThumbs!.length - 1
                                  ? 14 : 0,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                friendModel.friendsThumbs![index]!.thumbnailUrl ?? '',
                                fit: BoxFit.cover,
                                width: 74,
                                height: 76,
                                errorBuilder: (context, url, error) => Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey
                                  ),
                                  width: 74,
                                  height: 76,
                                  child: Center(
                                    child: Icon(Icons.error),
                                  ),
                                ),

                              ),
                            ),
                          ),
                          if(friendModel.friendsThumbs![index]!.type == 'video')...[
                            Container(
                              width: 74,
                              height: 76,
                              margin: EdgeInsets.only(
                                left: index == 0 ? 25 : 8,
                                right: index == (friendModel.friendsThumbs!
                                    .length - 1) ? 14 : 0,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    }
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  void _goToProfile(userId) async {
    controller.insertPage(ProfileScreen({"id": userId,},
    ));
  }

  bool  hasImages(FriendModel friendModel){
    return friendModel.friendsThumbs?.isNotEmpty ?? false;
  }





}

