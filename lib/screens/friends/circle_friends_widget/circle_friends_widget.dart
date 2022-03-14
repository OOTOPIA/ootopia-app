import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ootopia_app/data/models/friends/friend_model.dart';
import 'package:ootopia_app/screens/friends/add_friends/add_friends.dart';
import 'package:ootopia_app/screens/friends/circle_friends_page/circle_friends_page.dart';
import 'package:ootopia_app/screens/friends/friends_store.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

import 'circle_friends_widget_store.dart';

class CircleOfFriendWidget extends StatefulWidget {
  final bool isUserLogged;
  final String userId;

  const CircleOfFriendWidget({Key? key,
    required this.isUserLogged,
    required this.userId}) : super(key: key);

  @override
  State<CircleOfFriendWidget> createState() => _CircleOfFriendWidgetState();
}

class _CircleOfFriendWidgetState extends State<CircleOfFriendWidget> {

  late FriendsStore friendsStore;
  bool started = false;
  SmartPageController controller = SmartPageController.getInstance();
  CircleFriendsWidgetStore circleFriendsWidgetStore = CircleFriendsWidgetStore();

  @override
  void initState() {
    super.initState();
    if(!widget.isUserLogged){
      circleFriendsWidgetStore.getFriends(widget.userId);
    }
  }

  init(){
    print('widget.userId: ${widget.userId}');
    friendsStore  = Provider.of<FriendsStore>(context);
    if(!started && widget.isUserLogged){
      started = true;
      Future.delayed(Duration.zero,(){
        friendsStore.getRandomFriends(widget.userId);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    init();
    if(widget.isUserLogged){
      return Consumer<FriendsStore>(
          builder: (context, counter, _) {
            return body();
          }
      );
    }else{
      return Observer(
          builder: (_) {
            return body();
          }
      );
    }

  }

  Widget body(){
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: !widget.isUserLogged,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: GlobalConstants.of(context).screenHorizontalSpace),
              child: Divider(
                height: 1,
                color: Color(0xff707070).withOpacity(.5),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(right: 16, left: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(!friendsStore.isLoading && !circleFriendsWidgetStore.isLoading)...[
                  Padding(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: widget.isUserLogged ?
                              '${friendsStore.myFriendsDate?.total ?? 0} ' :
                              '${circleFriendsWidgetStore.friendsDate?.total ?? 0} ',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: LightColors.blue,
                                  fontWeight: FontWeight.w500)

                          ),
                          TextSpan(
                              text: AppLocalizations.of(context)!.friends,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: LightColors.black,
                                  fontWeight: FontWeight.w500)

                          ),
                        ])),
                  ),
                ],

                if(friendsStore.isLoading || circleFriendsWidgetStore.isLoading)...[
                  Padding(
                    padding: const EdgeInsets.only(top: 14.0, bottom: 18),
                    child: Shimmer.fromColors(
                      baseColor:  Colors.grey[300] ?? Colors.blue,
                      highlightColor:  Colors.grey[100] ?? Colors.blue,
                      child: Container(
                        height: 14,
                        width: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 14.0, bottom: 18),
                    child: Shimmer.fromColors(
                      baseColor:  Colors.grey[300] ?? Colors.blue,
                      highlightColor:  Colors.grey[100] ?? Colors.blue,
                      child: Container(
                        height: 14,
                        width: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]else if((!widget.isUserLogged && (circleFriendsWidgetStore.friendsDate?.friends?.isNotEmpty ?? false)) ||
                    (widget.isUserLogged && (friendsStore.myFriendsDate?.friends?.isNotEmpty ?? false)))...[
                  TextButton(
                    onPressed: (){
                      Future.delayed(Duration(milliseconds: 100),(){
                        controller.insertPage(CircleOfFriendPage(
                          userId: widget.userId,
                        ));
                      });
                    },
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.seeAll,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: LightColors.blue,
                          ),),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: LightColors.blue,
                          size: 14,

                        )
                      ],
                    ),
                  ),
                ]
              ],
            ),

          ),


          Visibility(
            visible: ListIsNotEmpty(),
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: widget.isUserLogged ? 70 : 56,
                child: listFriends()),
          ),
          Visibility(
            visible: !(friendsStore.isLoading ||
                (friendsStore.myFriendsDate?.friends?.isNotEmpty ?? false)) && widget.isUserLogged,
            child: Container(
                height: 70,
                margin: EdgeInsets.only(top: 12),
                child: buttonToAddFriends()),
          )
        ],

      ),
    );
  }

  Widget listFriends(){
    late List items;
    late int size;

    if(widget.isUserLogged){
      items = friendsStore.myFriendsDate?.friends ?? [] ;
      size = items.length + 1;
    }else{
      items = circleFriendsWidgetStore.friendsDate?.friends ?? [];
      size = items.length;
    }

    if(friendsStore.isLoading || circleFriendsWidgetStore.isLoading || items.length == 0){
      size =  10;
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: size,
      itemBuilder: (context, index) {
        if(widget.isUserLogged && index == 0 ){
          return buttonToAddFriends();
        }
        return Column(
          children: [
            Container(
                width: 56,
                height: 56,
                margin: EdgeInsets.only(
                    left: index == 0 ? 16 :
                    index == 1 && widget.isUserLogged ? 0 : 8,
                    right: index == size - 1 ? 24 : 0
                ),
                child:
                Stack(
                  children: [
                    itemShimmer(),
                    if(items.isNotEmpty)...[
                      itemFriend(items[widget.isUserLogged ? index - 1 : index]),
                    ]

                  ],
                )),
            if(widget.isUserLogged)...[
              SizedBox(
                height: 13,
              )
            ]

          ],
        );
      },
    );
  }

  Widget itemFriend(FriendModel friend){
    final double size = 56;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(size),
          child: Image.network(
            friend.photoUrl ?? '',
            fit: BoxFit.cover,
            width: size,
            height: size,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null){
                return child;
              }
              return itemShimmer();
            },


            errorBuilder: (context, url, error) => Image.asset(
              'assets/icons/user.png',
              fit: BoxFit.cover,
              width: size,
              height: size,

            ),),
        ),
        Material(
          borderRadius : BorderRadius.all(
            Radius.circular(size),
          ),
          color: Colors.transparent,
          child: Ink(
            child: InkWell(
              borderRadius : BorderRadius.all(
                Radius.circular(size),
              ),
              onTap: (){
                Future.delayed(Duration(microseconds: 80),(){
                  _goToProfile(friend.id);
                });
              },
              child: Container(
                height: size,
                width: size,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget itemShimmer(){
    double size = 56;
    return Shimmer.fromColors(
      baseColor:  Colors.grey[300] ?? Colors.blue,
      highlightColor:  Colors.grey[100] ?? Colors.blue,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle
        ),
      ),
    );
  }

  void _goToProfile(userId) async {
    controller.insertPage(ProfileScreen({"id": userId,}
    ));
  }

  Widget buttonToAddFriends() {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(

            width: 56,
            height: 56,
            child: RawMaterialButton(
              onPressed: () {
                Future.delayed(Duration(milliseconds: 100),()  {
                  controller.insertPage(
                      AddFriends());
                });
              },
              elevation: 0,
              hoverElevation: 0,
              focusElevation: 0,
              highlightElevation: 0,
              fillColor: Color(0xffD3D0D0),
              hoverColor: Colors.white,
              splashColor: Colors.black,

              child: SvgPicture.asset(
                'assets/icons/mais.svg',
                color: Colors.white,
                height: 30,
                width: 30,),
              padding: EdgeInsets.all(0.0),
              shape: CircleBorder(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 2),
            child: Text(
              AppLocalizations.of(context)!.addFriend,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 9,
                  color: Color(0xffB7B7B8)
              ),
            ),
          )
        ],
      ),
    );
  }

  ListIsNotEmpty() {
    if(widget.isUserLogged){
      return (friendsStore.isLoading || (friendsStore.myFriendsDate?.friends?.isNotEmpty ?? false));
    }else{
      return (circleFriendsWidgetStore.isLoading || (circleFriendsWidgetStore.friendsDate?.friends?.isNotEmpty ?? false));
    }
  }

}
