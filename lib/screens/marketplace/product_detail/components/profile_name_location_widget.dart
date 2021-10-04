import 'package:flutter/material.dart';

class ProfileNameLocationWidget extends StatelessWidget {
  final String profileImageUrl, profileName, location;
  const ProfileNameLocationWidget(
      {required this.profileImageUrl,
      required this.profileName,
      required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only( top: 16, bottom: 16.5, right: 26),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(profileImageUrl),
          ),
          Container(
            margin: EdgeInsets.only(left: 19),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileName,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
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
