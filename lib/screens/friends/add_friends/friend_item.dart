import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/data/models/friends/friend_model.dart';
import 'package:ootopia_app/screens/friends/friends_store.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class ItemFriendsWidget extends StatefulWidget {
  final FriendModel friendModel;
  ItemFriendsWidget(  this.friendModel, {Key? key}) : super(key: key);

  @override
  _ItemFriendsWidgetState createState() => _ItemFriendsWidgetState();
}

class _ItemFriendsWidgetState extends State<ItemFriendsWidget> {
  SmartPageController controller = SmartPageController.getInstance();
  late FriendsStore friendsStore;

  @override
  Widget build(BuildContext context) {
    friendsStore  = Provider.of<FriendsStore>(context);
    return  itemFriend( widget.friendModel);
  }

  Widget itemFriend(FriendModel friendModel){
    return Consumer<FriendsStore>(
        builder: (cont, counter, _) {
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
                    child:  Padding(
                      padding: EdgeInsets.fromLTRB(25, 4, 25, 4),
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
                          Visibility(
                            visible: friendModel.isFriend != null,
                            child: SizedBox(
                              height: 24,
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
                                      if(friendModel.isFriend != true){
                                        friendsStore.addFriend(friendModel);
                                        friendModel.isFriend = true;
                                        setState(() {});
                                      }else{
                                        _goToProfile(friendModel.id);
                                      }
                                    });
                                  },
                                  child: Text(
                                    getIfIsFriend(friendModel) ?
                                    AppLocalizations.of(context)!.friend:
                                    AppLocalizations.of(context)!.add,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ),
                          )
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
                                  right: index == friendModel.friendsThumbs!.length ? 14 : 0,
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
                                right: index == (friendModel.friendsThumbs!
                                    .length - 1) ? 14 : 0,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  friendModel.friendsThumbs![index]!.thumbnailUrl ?? '',
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
          );
        }
    );
  }

  void _goToProfile(userId) async {
    controller.insertPage(ProfileScreen({"id": userId,},
    ));
  }

  getIfIsFriend(FriendModel friendModel) {
    if(friendModel.isFriend == true){
      return true;
    }
    bool isFriend = false;
    friendsStore.myFriendsDate?.friends?.forEach((element) {
      if(element!.id == friendModel.id){
        isFriend = true;
      }
    });
    return isFriend;
  }


}

