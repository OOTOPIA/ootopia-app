import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImagePostTimeline extends StatefulWidget {
  const ImagePostTimeline({
    Key? key,
    required this.image,
    this.onDoubleTapVideo,
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
      fit: BoxFit.cover,
    );
    Size imageSize = Size(100.toDouble(), 100.toDouble());

    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener(
      (ImageInfo image, bool synchronousCall) {
        imageSize =
            Size(image.image.width.toDouble(), image.image.height.toDouble());
        completer.complete(image.image);
        setState(() {});
      },
    ));

    return GestureDetector(
      onDoubleTap: () {
        if (this.widget.onDoubleTapVideo != null) {
          this.widget.onDoubleTapVideo!();
        }
      },
      child: Container(
        height: imageSize.height > MediaQuery.of(context).size.height * .7
            ? MediaQuery.of(context).size.height * .6
            : imageSize.height,
        width: imageSize.width,
        decoration: BoxDecoration(
            color: Color(0xff1A4188),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            image: DecorationImage(
              fit: imageSize.height > MediaQuery.of(context).size.height * .7
                  ? BoxFit.fitWidth
                  : BoxFit.fill,
              alignment: FractionalOffset.center,
              image: NetworkImage(widget.image),
            )),
      ),
    );
  }
}
