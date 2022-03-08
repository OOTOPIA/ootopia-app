import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/data/models/friends/friend_model.dart';
import 'package:ootopia_app/screens/friends/add_friends/add_friends_store.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';



class AddFriends extends StatefulWidget {

  @override
  State<AddFriends> createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  TextEditingController messageController = TextEditingController();
  AddFriendsStore addFriendsStore = AddFriendsStore();
  SmartPageController controller = SmartPageController.getInstance();


  @override
  Widget build(BuildContext context) {
    return  Observer(
        builder: (context) {
          return Stack(
            children: [
              BackgroundButterflyTop(positioned: -59),
              BackgroundButterflyBottom(positioned: -50),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0, left: 28),
                      child: Text(AppLocalizations.of(context)!.addFriends,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 21,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, left: 28),
                      child: Text(AppLocalizations.of(context)!.searchFriendsMsg,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 12, 14, 0),
                      child: Container(
                        height: 42,
                        child: TextField(
                          controller: messageController,
                          textCapitalization: TextCapitalization.words,
                          textAlignVertical: TextAlignVertical.center,
                          textInputAction: TextInputAction.search,
                          style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.normal),
                          onEditingComplete: (){
                            addFriendsStore.searchNewName(messageController.text);
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.white.withOpacity(0.3),
                            prefixIcon: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: (){
                                addFriendsStore.searchNewName(messageController.text);
                              },
                              icon: Container(
                                margin: EdgeInsets.symmetric(horizontal: 12),
                                child: SvgPicture.asset(
                                  'assets/icons/search.svg',
                                  color: LightColors.blue,
                                ),
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top:16, right: 16),
                            hintText: AppLocalizations.of(context)!.searchFriends,
                            hintStyle: GoogleFonts.roboto(
                                fontSize: 16,
                                color: LightColors.grey,
                                fontWeight: FontWeight.w400),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: LightColors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: LightColors.grey)),
                          ),
                        ),
                      ),
                    ),

                    if(addFriendsStore.users.isEmpty)...[

                      if(addFriendsStore.searchIsEmpty)...[
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.fromLTRB(30, 30, 30, 6),
                          child: Text(AppLocalizations.of(context)!.userNotFound,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 21,
                              color: LightColors.blue,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.fromLTRB(30, 0, 30, 15),
                          child: Text(AppLocalizations.of(context)!.userNotFoundMsg,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                      ListView.builder(
                          itemCount: 11,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return  itemShimmer();
                          }
                      ),
                    ]else ...[
                      ListView.builder(
                          itemCount: addFriendsStore.users.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return  itemFriend(addFriendsStore.users[index]);
                          }
                      ),
                    ],
                    SizedBox(height: 16),
                  ],
                ),
              )
            ],
          );
        }
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
            padding: EdgeInsets.fromLTRB(25, 31, 14, 0),
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
                  height: 11,
                  width: 80,
                  color: Colors.white,
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
    double size = MediaQuery.of(context).size.width - (25+14+48+82);
    bool isFriend = false;
    addFriendsStore.usersIdAdded.forEach((element) {
      if(element == friendModel.id){
        isFriend = true;
      }
    });
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(25, 31, 14, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      borderRadius: BorderRadius.circular(size),
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
                      style: TextStyle(
                        color: LightColors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      friendModel.location(),
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
              if(isFriend)...[
                TextButton(onPressed: (){
                  Future.delayed(Duration(milliseconds: 80),(){
                    _goToProfile(friendModel.id);
                  });
                },
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.seeProfile,
                          style: TextStyle(
                            color: LightColors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_sharp,
                          color: LightColors.blue,
                          size: 12,
                        )
                      ],
                    ))
              ]else...[
                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all<Size>(Size(double.infinity, 10)),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular
                                (20),
                              side: BorderSide.none),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(LightColors.blue),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 18)),
                      ),
                      onPressed: () {
                        Future.delayed(Duration(milliseconds: 80),(){
                          addFriendsStore.addFriend(friendModel.id!);
                          //controller.insertPage(AddFriends());
                        });
                      },
                      child: Text(
                        AppLocalizations.of(context)!.add.toLowerCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                )
              ]
            ],
          ),
        ),
        if(friendModel.friendsThumbs?.isNotEmpty ?? false)...[
          Container(
            height: 90,
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
                        ),
                      ),
                      Container(
                        width: 74,
                        height: 76,
                        margin: EdgeInsets.only(
                          left: index == 0 ? 25 : 8,
                          top: 14,
                          right: index == 10 ? 14 : 0,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            friendModel.friendsThumbs![index]!.thumbnailUrl ?? '',
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
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
                            top: 14,
                            right: index == 10 ? 14 : 0,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                        ),

                      ]
                    ],
                  );
                }
            ),
          )
        ]
      ],
    );
  }

  void _goToProfile(userId) async {
    controller.insertPage(ProfileScreen({"id": userId,},));
  }


}
