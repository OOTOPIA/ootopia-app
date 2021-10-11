import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/marketplace/components/get_adaptive_size.dart';

class HorizontalExpandedImageWidget extends StatelessWidget {
  final String urlImage;
  const HorizontalExpandedImageWidget({required this.urlImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getAdaptiveSize(MediaQuery.of(context).size.width > 720 ? MediaQuery.of(context).size.height * 0.3 : MediaQuery.of(context).size.height * 0.5, context),
      width: double.infinity,
      child: ClipRRect(
        child: FittedBox(
          fit: BoxFit.cover,
          child: Image.network(urlImage),
        ),
      ),
    );
  }
}
