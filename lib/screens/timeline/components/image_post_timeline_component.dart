import 'package:flutter/material.dart';

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
    return Container(
      child:  
        Image.network(
          widget.image,
          fit: BoxFit.cover,
        ),
      );
  }
}