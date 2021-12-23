import 'package:flutter/material.dart';
import 'package:ootopia_app/shared/global-constants.dart';

class HorizontalExpandedImageWidget extends StatelessWidget {
  final String urlImage;
  const HorizontalExpandedImageWidget({required this.urlImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: GlobalConstants.of(context).intermediateSpacing,
      ),
      height: MediaQuery.of(context).size.width > 720
          ? MediaQuery.of(context).size.height * 0.3
          : MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FittedBox(
          fit: BoxFit.cover,
          child: Image.network(urlImage),
        ),
      ),
    );
  }
}
