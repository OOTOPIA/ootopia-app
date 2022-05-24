import 'package:flutter/material.dart';

class AvatarPhotoWidget extends StatefulWidget {
  final String? photoUrl;
  final double? sizePhotoUrl;

  AvatarPhotoWidget({Key? key, this.photoUrl, this.sizePhotoUrl})
      : super(key: key);

  @override
  _AvatarPhotoWidgetState createState() => _AvatarPhotoWidgetState();
}

class _AvatarPhotoWidgetState extends State<AvatarPhotoWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.sizePhotoUrl != null ? widget.sizePhotoUrl : 124,
        height: widget.sizePhotoUrl != null ? widget.sizePhotoUrl : 124,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
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
    );
  }
}
