import 'dart:async';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';

class ImagePostTimeline extends StatefulWidget {
  const ImagePostTimeline({
    Key? key,
    required this.image,
    required this.onDoubleTapVideo,
  }) : super(key: key);

  final String image;
  final Function? onDoubleTapVideo;

  @override
  _ImagePostTimeline createState() => _ImagePostTimeline();
}

class _ImagePostTimeline extends State<ImagePostTimeline> {
  @override
  Widget build(BuildContext context) {
    Image image = Image.network(
      widget.image,
    );
    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener(
      (ImageInfo image, bool synchronousCall) {
        completer.complete(image.image);
      },
    ));



    return GestureDetector(
      onDoubleTap: () {
        if (this.widget.onDoubleTapVideo != null) {
          this.widget.onDoubleTapVideo!();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Color(0xff000000),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            image: DecorationImage(
              fit: BoxFit.contain,
              alignment: FractionalOffset.center,
              image: NetworkImage(widget.image),
            )
        ),

      ),
    );
  }
}
