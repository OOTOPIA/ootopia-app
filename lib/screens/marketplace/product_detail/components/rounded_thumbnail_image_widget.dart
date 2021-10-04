import 'package:flutter/material.dart';

class RoundedThumbnailImageWidget extends StatelessWidget {
  final double width, height, radius;
  final String imageUrl;
  const RoundedThumbnailImageWidget(
      {required this.imageUrl,
      this.height = 91,
      this.radius = 20,
      this.width = 91});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: FittedBox(
          fit: BoxFit.cover,
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
