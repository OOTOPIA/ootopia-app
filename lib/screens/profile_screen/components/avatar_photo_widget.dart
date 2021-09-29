import 'package:flutter/material.dart';

class AvatarPhotoWidget extends StatefulWidget {
  String? photoUrl;
  bool isBadges;
  VoidCallback onTap;
  double? sizePhotoUrl;

  AvatarPhotoWidget(
      {Key? key,
      this.photoUrl,
      required this.isBadges,
      required this.onTap,
      this.sizePhotoUrl})
      : super(key: key);

  @override
  _AvatarPhotoWidgetState createState() => _AvatarPhotoWidgetState();
}

class _AvatarPhotoWidgetState extends State<AvatarPhotoWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: widget.sizePhotoUrl != null ? widget.sizePhotoUrl : 124,
        height: widget.sizePhotoUrl != null ? widget.sizePhotoUrl : 124,
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
                  'assets/icons/user.png',
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
              child: InkWell(
                onTap: widget.onTap,
                child: Image.asset(
                  //TODO verificar nome do icone
                  "assets/icons_profile/badges_icon.png",
                  width: 33,
                  height: 33,
                ),
              ),
            )
          : Container(),
    ]);
  }
}
