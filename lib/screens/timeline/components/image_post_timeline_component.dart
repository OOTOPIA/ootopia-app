import 'dart:ui' as ui;
import 'dart:async';
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
    BoxFit boxFit = BoxFit.cover;
    Size imageSize = Size(100.0, 100.0);

    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener(
      (ImageInfo image, bool synchronousCall) {
        imageSize = Size(image.image.width.toDouble(), image.image.height.toDouble());
        if(imageSize.height <= imageSize.width){
          boxFit = BoxFit.fitWidth;
        }else{
          boxFit = BoxFit.fitHeight;
        }
        if (mounted) setState(() {});
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
            color: Color(0xff000000).withOpacity(1),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            image: DecorationImage(
              fit: BoxFit.cover,
              alignment: FractionalOffset.center,
              image: NetworkImage(widget.image),
            )
        ),
        child: Stack(
          children: [
            //BLUR
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              child: BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                  )),
            ),

            //IMAGE
            Align(
              alignment: Alignment.center,
              child:  ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: Image.network(
                      widget.image,
                      fit: boxFit,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
