import 'package:flutter/material.dart';

class AlbumProfileWidget extends StatelessWidget {
  VoidCallback onTap;
  String albumName;
  String? photoAlbumUrl;

  AlbumProfileWidget({
    Key? key,
    required this.onTap,
    required this.albumName,
    this.photoAlbumUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              color: Color(0xffDEDCDC),
              border: photoAlbumUrl != null
                  ? Border.fromBorderSide(
                      BorderSide(width: 3, color: Color(0xff003694)))
                  : null,
              borderRadius: BorderRadius.circular(100)),
          child: photoAlbumUrl == null
              ? Icon(Icons.add, color: Colors.white)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset("assets/icons_profile/profile.png"),
                ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          albumName,
          style: photoAlbumUrl != null
              ? TextStyle(
                  fontSize: 12,
                  color: Color(0xff003694),
                  fontWeight: FontWeight.bold)
              : TextStyle(
                  fontSize: 12,
                  color: Color(0xffDEDCDC),
                  fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}