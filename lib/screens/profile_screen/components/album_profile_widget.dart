import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class AlbumProfileWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String albumName;
  final String? photoAlbumUrl;

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
                color: photoAlbumUrl == null
                    ? Color(0xffDEDCDC)
                    : Colors.transparent,
                border: photoAlbumUrl != null
                    ? Border.fromBorderSide(
                        BorderSide(width: 3, color: Color(0xff003694)))
                    : null,
                borderRadius: BorderRadius.circular(100)),
            child: photoAlbumUrl == null
                ? Icon(Icons.add, color: Colors.white)
                : Icon(
                    FeatherIcons.image,
                    color: Color(0xff003694),
                  )),
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
