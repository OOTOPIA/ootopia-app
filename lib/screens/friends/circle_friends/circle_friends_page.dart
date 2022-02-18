import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/friends/add_friends/add_friends.dart';
import 'package:ootopia_app/screens/friends/circle_friends/circle_friends_store.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';


class CircleOfFriendPage extends StatefulWidget {


  @override
  State<CircleOfFriendPage> createState() => _CircleOfFriendPageState();
}

class _CircleOfFriendPageState extends State<CircleOfFriendPage> {

  TextEditingController messageController = TextEditingController();
  CircleFriendsStore circleFriendsStore = CircleFriendsStore();
  SmartPageController controller = SmartPageController.getInstance();
  List<String> orderBy = [];
  String orderBySelected = '';



  init(){
    if(orderBy.isEmpty){
      orderBy = [
        AppLocalizations.of(context)!.alphabeticalOrder,
        AppLocalizations.of(context)!.mostRecent,
        AppLocalizations.of(context)!.older,
      ];
      orderBySelected = AppLocalizations.of(context)!.alphabeticalOrder;
    }
  }



  @override
  Widget build(BuildContext context) {
    init();
    print(MediaQuery.of(context).size.width);

    print(MediaQuery.of(context).size.width);
    return  Observer(
        builder: (context) {
          return LoadingOverlay(
            isLoading: circleFriendsStore.isLoading,

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
                                Text(AppLocalizations.of(context)!.circleOfFriends,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Text( "${circleFriendsStore.friends.length} ${AppLocalizations.of(context)!.friends}",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12,
                                      color: Color(0xff939598),
                                    ),
                                  ),
                                ),
                              ],
                            ),

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
                                child: Text(MediaQuery.of(context).size.width <= 414 ?
                                AppLocalizations.of(context)!.add.toLowerCase():
                                  AppLocalizations.of(context)!.addFriend.toLowerCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))
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





                      ListView.builder(
                          itemCount: 11,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return  itemShimmer();
                          }
                      ),

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

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          child: Container(
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 14, left: 24, bottom: 18),
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
              Navigator.of(context).pop();
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
                Container(
                  height: 13,
                  width: 13,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    color: orderBySelected == orderBy[index] ?
                    LightColors.blue :
                    LightColors.white,
                    shape: BoxShape.circle,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }



}
