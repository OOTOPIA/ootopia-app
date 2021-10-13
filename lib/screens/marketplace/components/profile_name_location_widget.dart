import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/marketplace/components/get_adaptive_size.dart';

class ProfileNameLocationWidget extends StatelessWidget {
  final String profileImageUrl, profileName, location;
  const ProfileNameLocationWidget(
      {required this.profileImageUrl,
      required this.profileName,
      required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: getAdaptiveSize(16, context),
          bottom: getAdaptiveSize(16.5, context),
          right: getAdaptiveSize(26, context)),
      child: Row(
        children: [
          CircleAvatar(
            radius: getAdaptiveSize(18, context),
            backgroundImage: profileImageUrl.isEmpty
                ? AssetImage("assets/icons_profile/profile.png")
                : NetworkImage(profileImageUrl) as ImageProvider,
          ),
          Container(
            margin: EdgeInsets.only(left: getAdaptiveSize(19, context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileName,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                if (location.isNotEmpty)
                  Text(
                    location,
                    style: TextStyle(fontSize: 12),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
