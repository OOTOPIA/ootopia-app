import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ootopia_app/data/models/friends/friend_model.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/friends/add_friends/add_friends.dart';
import 'package:ootopia_app/screens/friends/friends_store.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

import 'circle_friends_store.dart';


class CircleOfFriendPage extends StatefulWidget {
  final String userId;

  CircleOfFriendPage({Key? key,required this.userId}) : super(key: key);


  @override
  State<CircleOfFriendPage> createState() => _CircleOfFriendPageState();
}

class _CircleOfFriendPageState extends State<CircleOfFriendPage> {

  late AuthStore authStore;
  CircleFriendsStore circleFriendsStore = CircleFriendsStore();
  late FriendsStore friendsStore;
  SmartPageController controller = SmartPageController.getInstance();
  List<String> orderBy = [];
  String orderBySelected = '';

  @override
  void initState() {
    init();
    super.initState();
  }


  void init(){
    Future.delayed(Duration.zero, (){
      if(orderBy.isEmpty){
        orderBy = [
          AppLocalizations.of(context)!.alphabeticalOrder,
          AppLocalizations.of(context)!.mostRecent,
          AppLocalizations.of(context)!.older,
        ];
        orderBySelected = orderBy[0];
      }
      if(isPageOfUserLogged()){
        friendsStore.init(widget.userId);
      }else{
        circleFriendsStore.init(widget.userId, authStore.currentUser != null);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);
    friendsStore  = Provider.of<FriendsStore>(context);
    //init();
    return  Observer(
        builder: (context) {
          return Stack(
            children: [
              BackgroundButterflyTop(positioned: -59),
              BackgroundButterflyBottom(positioned: -50),
              if(isPageOfUserLogged())...[
                Consumer<FriendsStore>(
                    builder: (cont, friend, child) {
                      return body();
                    }
                )
              ]else...[
                Observer(
                    builder: (_) {
                      return body();
                    })
              ]
            ],
          );
        }
    );
  }

  Widget body() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (loadMoreFriends(scrollInfo)) {

          Future.delayed(Duration.zero,() async {
            if(isPageOfUserLogged()){
              await friendsStore.getMoreFriends(widget.userId);
            }else{
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
              padding: const EdgeInsets.only(top: 14.0, left: 28,
                  right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Text(AppLocalizations.of(context)!.friends,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: circleFriendsStore.isLoading || friendsStore.isLoadingGetAllFriends?
                        Shimmer.fromColors(
                          baseColor:  Colors.grey[300] ?? Colors.blue,
                          highlightColor:  Colors.grey[100] ?? Colors.blue,
                          child: Container(
                            height: 10,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        )
                            :
                        Text(
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

                  if(isPageOfUserLogged())...[
                    ElevatedButton(
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(Size(double.infinity, 35)),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular
                                  (20),
                                side: BorderSide.none),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(LightColors.blue),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 24)),
                        ),
                        onPressed: () {
                          Future.delayed(Duration(milliseconds: 100),(){
                            controller.insertPage(AddFriends());
                          });
                        },
                        child: Text(MediaQuery.of(context).size.width <= 300 ?
                        AppLocalizations.of(context)!.add:
                        AppLocalizations.of(context)!.addFriend,
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
              onTap: (){
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

            if(circleFriendsStore.isLoading || friendsStore.isLoadingGetAllFriends)...[
              ListView.builder(
                  itemCount: 11,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return  itemShimmer();
                  }
              ),
            ]else  if(isPageOfUserLogged() && allFriendsIsHide())...[
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(30, 48, 30, 8),
                child: Text(AppLocalizations.of(context)!.userNotFound,
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
                child: Text(AppLocalizations.of(context)!.userNotFoundMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: LightColors.grey.withOpacity(0.7),
                  ),
                ),
              ),
            ]else...[
              ListView.builder(
                  itemCount: isPageOfUserLogged() ?
                  friendsStore.friendsDate?.friends?.length ?? 0 :
                  circleFriendsStore.friendsDate!.friends!.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return  itemFriend(
                        isPageOfUserLogged() ?
                        friendsStore.friendsDate!.friends![index]! :
                        circleFriendsStore.friendsDate!.friends![index]!);
                  }
              ),
              SizedBox(height: 50,),
            ],

            SizedBox(height: 16),

          ],
        ),
      ),
    );
  }

  Widget itemShimmer(){
    double size = MediaQuery.of(context).size.width - (25+14+48+82);
    return Shimmer.fromColors(
      baseColor:  Colors.grey[300] ?? Colors.blue,
      highlightColor:  Colors.grey[100] ?? Colors.blue,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(25, 31, 25, 0),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 11,
                        width: size*0.35,
                        color: Colors.white,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 6),
                        height: 8,
                        width: size*0.23,
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
                      borderRadius: BorderRadius.all(Radius.circular(12))
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                itemCount: 11,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return  Container(
                    margin: EdgeInsets.only(
                      left: index == 0 ? 25 : 8,
                      top: 14,
                      right: index == 10 ? 14 : 0,
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
                }
            ),
          )
        ],
      ),
    );
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

                        if(isPageOfUserLogged())...[
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
                                    friendsStore.removeFriend(friendModel);
                                    setState(() {});
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
                        ]else if(!isPageOfUserLogged() && friendModel.isFriend != null &&
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
                                        friendsStore.removeFriend(friendModel);
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
                                errorBuilder: (context, url, error) => Center(
                                  child: Icon(Icons.error),
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

  Widget rankedItemSelect(int index, context){
    return  Material(
      color: orderBySelected == orderBy[index] ?
      LightColors.blue.withOpacity(0.18) :
      LightColors.white,
      child: Ink(
        child: InkWell(
          splashColor: LightColors.blue,
          onTap: (){
            Future.delayed(Duration(milliseconds: 100),(){
              setState(() {
                orderBySelected = orderBy[index];
              });
              if(isPageOfUserLogged()){
                friendsStore.changeOrderBy(index);
                Navigator.of(context).pop();
                friendsStore.getFriends(widget.userId);
              }else {
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
                Text(orderBy[index],
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16
                  ),),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goToProfile(userId) async {
    controller.insertPage(ProfileScreen(
      {"id": userId,},
    ));
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
                    padding: const EdgeInsets.only(top: 14, left: 24, bottom: 12),
                    child: Text(AppLocalizations.of(context)!.orderBy,
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
            )

        );
      },
    );
  }

  bool isPageOfUserLogged(){
    return widget.userId == authStore.currentUser?.id;
  }

  bool  hasImages(FriendModel friendModel){
    return friendModel.friendsThumbs?.isNotEmpty ?? false;
  }

  bool allFriendsIsHide(){

    if(isPageOfUserLogged() && friendsStore.friendsDate != null){
      bool allFriendsIsHide = true;
      friendsStore.friendsDate!.friends!.forEach((element) {
        if(element?.remove != true ){
          allFriendsIsHide = false;
        }
      });
      return allFriendsIsHide;
    }
    return false;
  }

  String getAmountOfFriends() {
    if(isPageOfUserLogged()){
      return '${friendsStore.friendsDate?.total ?? 0}';
    }else{
      return '${circleFriendsStore.friendsDate?.total ?? 0}';
    }
  }

  bool loadMoreFriends(ScrollNotification scrollInfo) {
    late bool status;
    if(isPageOfUserLogged()){
      status = !friendsStore.loadingMoreFriends && friendsStore.hasMoreFriends;
    }else{
      status =  !circleFriendsStore.loadingMoreFriends && circleFriendsStore.hasMoreFriends;
    }
    return status && scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent*0.6;
  }

}
