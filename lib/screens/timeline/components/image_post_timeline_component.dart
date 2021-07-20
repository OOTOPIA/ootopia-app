import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImagePostTimeline extends StatefulWidget {
  const ImagePostTimeline({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String image;

  @override
  _ImagePostTimeline createState() => _ImagePostTimeline();
}

class _ImagePostTimeline extends State<ImagePostTimeline> {
  @override
  Widget build(BuildContext context) {
    Image image = Image.network(
      "https://images.unsplash.com/photo-1533422902779-aff35862e462?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8aG9yaXpvbnRhbHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80",
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

    return Container(
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
                ? BoxFit.fill
                : BoxFit.fitWidth,
            alignment: FractionalOffset.center,
            image: NetworkImage(
                "https://images.unsplash.com/photo-1533422902779-aff35862e462?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8aG9yaXpvbnRhbHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80"),
          )),
      // constraints: BoxConstraints(
      //   maxHeight: imageSize.height > (MediaQuery.of(context).size.height / 2)
      //       ? (MediaQuery.of(context).size.height / 2)
      //       : imageSize.height - 48,
      // ),
      // child: Center(
      //     child:
      //         ClipRRect(borderRadius: BorderRadius.circular(20), child: image)),
    );
  }
}
