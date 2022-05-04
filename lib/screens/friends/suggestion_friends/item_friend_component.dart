import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/friends/friend_model.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemFriend extends StatelessWidget {
  final FriendModel friend;
  ItemFriend({Key? key, required this.friend}) : super(key: key);
  final SmartPageController controller = SmartPageController.getInstance();

  @override
  Widget build(BuildContext context) {
    final double size = 56;
    return Container(
      height: 150,
      width: 100,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: LightColors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(size),
                child: Image.network(
                  friend.photoUrl ?? '',
                  fit: BoxFit.cover,
                  width: size,
                  height: size,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    return child;
                  },
                  errorBuilder: (context, url, error) => Image.asset(
                    'assets/icons/user.png',
                    fit: BoxFit.cover,
                    width: size,
                    height: size,
                  ),
                ),
              ),
              Material(
                borderRadius: BorderRadius.all(
                  Radius.circular(size),
                ),
                color: Colors.transparent,
                child: Ink(
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(size),
                    ),
                    onTap: () {
                      Future.delayed(Duration(microseconds: 80), () {
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
          ),
          SizedBox(height: 8),
          Text(
            friend.fullname!,
            maxLines: 2,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            friend.isFriend != null && friend.isFriend!
                ? AppLocalizations.of(context)!.joinedOotopia
                : AppLocalizations.of(context)!.suggestedbyOotopia,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  void _goToProfile(userId) async {
    controller.insertPage(ProfileScreen({
      "id": userId,
    }));
  }
}
