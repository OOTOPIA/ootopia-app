import 'package:flutter/material.dart';

class AvatarPhotoWidget extends StatefulWidget {
  String? photoUrl;
  bool isBadges;

  AvatarPhotoWidget({
    Key? key,
    this.photoUrl,
    required this.isBadges,
  }) : super(key: key);

  @override
  _AvatarPhotoWidgetState createState() => _AvatarPhotoWidgetState();
}

class _AvatarPhotoWidgetState extends State<AvatarPhotoWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: 124,
        height: 124,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.fromBorderSide(BorderSide(
              color: widget.isBadges ? Color(0xff39A7B2) : Color(0xff000000),
              width: 3)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: widget.photoUrl == null ||
                  (widget.photoUrl != null && widget.photoUrl!.isEmpty)
              ? Image.asset(
                  "assets/icons_profile/profile.png",
                  fit: BoxFit.cover,
                )
              : Image.network(
                  widget.photoUrl!,
                  fit: BoxFit.cover,
                ),
        ),
      ),
      widget.isBadges
          ? Positioned(
              top: 8,
              right: 4,
              child: Image.asset(
                //TODO verificar nome do icone
                "assets/icons_profile/badges_icon.png",
                width: 33,
                height: 33,
              ),
            )
          : Container(),
    ]);
  }
}
