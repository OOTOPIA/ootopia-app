import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/marketplace/components/get_adaptive_size.dart';

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
      height: getAdaptiveSize(height, context),
      width: getAdaptiveSize(width, context),
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
