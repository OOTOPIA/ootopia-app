import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/screens/friends/add_friends/friend_item.dart';
import 'package:ootopia_app/screens/friends/friends_store.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';



class AddFriends extends StatefulWidget {

  @override
  State<AddFriends> createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  TextEditingController messageController = TextEditingController();
  late FriendsStore friendsStore;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      friendsStore.cleanSearchPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    friendsStore  = Provider.of<FriendsStore>(context);
    return Consumer<FriendsStore>(
        builder: (cont, counter, _) {
          return Stack(
            children: [
              BackgroundButterflyTop(positioned: -59),
              BackgroundButterflyBottom(positioned: -50),
              NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!friendsStore.loadingMoreUsersSearch &&
                      scrollInfo.metrics.pixels >= scrollInfo.metrics
                          .maxScrollExtent*0.6 &&
                      friendsStore.hasMoreUsersSearch ) {
                    friendsStore.getMoreUserBySearch();
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
                        padding: const EdgeInsets.fromLTRB(25, 12, 25, 0),
                        child: Container(
                          height: 42,
                          child: TextField(
                            controller: messageController,
                            onChanged: (value){
                              if(value.isEmpty){
                                friendsStore.cleanSearchPage();
                              }
                            },
                            textCapitalization: TextCapitalization.words,
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.search,
                            style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.normal),
                            onEditingComplete: (){
                              friendsStore.searchNewName(messageController.text);
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white.withOpacity(0.3),
                              prefixIcon: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: (){
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
                      Visibility(
                        visible: !friendsStore.isLoading && !(friendsStore.usersSearch.friends?.isEmpty ?? true),
                        child: Container(
                          margin: EdgeInsets.only(left: 25, top: 8),
                          child: Text('${friendsStore.usersSearch.total} '
                              '${AppLocalizations.of(context)!.resultsFor} '
                              '\"${friendsStore.lastName}\"',
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 12,
                                color: LightColors.blue,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                      ),

                      if(friendsStore.isLoadingSearch)...[
                        SizedBox(
                          height: 6,
                        ),
                        ListView.builder(
                            itemCount: 11,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return  itemShimmer();
                            }
                        ),
                      ]else if(friendsStore.searchIsEmpty)...[
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
                        )
                      ]else...[
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          height: MediaQuery.of(context).size.height - 250,
                          child: ListView.builder(
                              itemCount: friendsStore.usersSearch.friends!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    margin: EdgeInsets.only(bottom: (index == friendsStore.usersSearch.total! - 1) ? 100 : 0
                                    ),
                                    child: ItemFriendsWidget(friendsStore.usersSearch.friends![index]!));
                              }
                          ),
                        ),
                      ],
                      Visibility(
                          visible: friendsStore.loadingMoreUsersSearch,
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
                                  valueColor: AlwaysStoppedAnimation<Color>(LightColors.blue),
                                ),
                              ),
                            ),
                          )
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
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
            padding: EdgeInsets.fromLTRB(25, 16, 25, 0),
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
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return  Container(
                    margin: EdgeInsets.only(
                      left: index == 0 ? 25 : 8,
                      top: 14,
                      right: index == 5 ? 14 : 0,
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

}


