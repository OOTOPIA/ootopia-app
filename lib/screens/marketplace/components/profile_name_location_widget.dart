import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        top: 16,
        bottom: 16,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: profileImageUrl.isEmpty
                ? AssetImage("assets/icons_profile/profile.png")
                : NetworkImage(profileImageUrl) as ImageProvider,
          ),
          Container(
            margin: EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profileName,
                    style: GoogleFonts.roboto(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                Text(
                  location,
                  style: GoogleFonts.roboto(fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
