import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ootopia_app/theme/light/colors.dart';


class CircleOfFriendWidget extends StatefulWidget {
  final bool isUserLogged;
  final String userId;

  const CircleOfFriendWidget({Key? key, required this.isUserLogged,required this.userId}) : super(key: key);

  @override
  State<CircleOfFriendWidget> createState() => _CircleOfFriendWidgetState();
}

class _CircleOfFriendWidgetState extends State<CircleOfFriendWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 16, left: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(AppLocalizations.of(context)!.circleOfFriends,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){

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
              ],
            ),

          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              child: list(["sda","sda","sda","sda","sda","sda","sda"])),
        ],
      ),
    );
  }

  Widget list(List items){
    int size = widget.isUserLogged ? items.length + 1 : items.length;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: size,
      itemBuilder: (context, index) {
        if(widget.isUserLogged && index == 0 ){
          return Container(
            margin: EdgeInsets.only(left: 24),
            width: 56,
            height: 56,
            child: RawMaterialButton(
              onPressed: () {
                Future.delayed(Duration(milliseconds: 100),(){

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
          );
        }
        return Container(
            width: 56,
            height: 56,
            margin: EdgeInsets.only(
                left: index == 0 ? 16 : 7,
              right: index == size - 1 ? 24 : 0
            ),
            child: item(items[widget.isUserLogged ? index - 1 : index]));
      },
    );
  }

  Widget item(item){
    return ClipRRect(
      borderRadius: BorderRadius.circular(56),
      child: Image.network(
        item,
        fit: BoxFit.cover,
        width: 56,
        height: 56,
        errorBuilder: (context, url, error) => Image.asset(
          'assets/images/empty_photo_profile.png',
          fit: BoxFit.cover,
          width: 100,
          height: 56,

        ),),
    );
  }




}
