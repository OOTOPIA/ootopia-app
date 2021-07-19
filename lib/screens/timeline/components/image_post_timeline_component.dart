import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImagePostTimeline extends StatefulWidget {
  const ImagePostTimeline(
    {Key? key,
    required this.image,
    }) : super(key: key);

  final String image;

  @override
  _nameState createState() => _nameState();
} 


class _nameState extends State<ImagePostTimeline> {
  @override
  Widget build(BuildContext context) {
    Image image = Image.network(
       widget.image,
      fit: BoxFit.cover,
    );
    Size ImageSize = Size(100.toDouble(), 100.toDouble());

    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image
      .resolve(ImageConfiguration())
      .addListener(
        ImageStreamListener(
          (ImageInfo image, bool synchronousCall) {
            ImageSize = Size(image.image.width.toDouble(), image.image.height.toDouble());
            completer.complete(image.image);
            setState(() {
            });
          },
        )
      );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20.0)
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: ImageSize.height > (MediaQuery.of(context).size.height / 2)  ?  (MediaQuery.of(context).size.height / 2) : ImageSize.height - 48 ,
      ),
      child: 
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular((MediaQuery.of(context).size.width - 12 ) < ImageSize.width  &&  ImageSize.height < (MediaQuery.of(context).size.height / 2) ? 20 : 0),
            child:  image
          )
        ),
    );
  }
}