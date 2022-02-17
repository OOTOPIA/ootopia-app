import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/friends/add_friends/add_friends_store.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:shimmer/shimmer.dart';



class AddFriends extends StatefulWidget {

  @override
  State<AddFriends> createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  TextEditingController messageController = TextEditingController();
  AddFriendsStore addFriendsStore = AddFriendsStore();



  @override
  Widget build(BuildContext context) {
    return  Observer(
        builder: (context) {
          return LoadingOverlay(
            isLoading: addFriendsStore.isLoading,

            child: Stack(
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
                              addFriendsStore.searchName(messageController.text);
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white.withOpacity(0.3),
                              prefixIcon: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: (){
                                  addFriendsStore.searchName(messageController.text);
                                },
                                icon: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                  child: SvgPicture.asset(
                                    'assets/icons/ooz-coin-blue-small.svg',
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
                        ListView.builder(
                            itemCount: 11,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return  itemShimmer();
                            }
                        ),
                      ]else ...[

                      ],
                      SizedBox(height: 16),





                    ],
                  ),
                )
              ],
            ),
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


}
