import 'package:flutter/material.dart';

class HorizontalExpandedImageWidget extends StatelessWidget {
  final String urlImage;
  const HorizontalExpandedImageWidget({required this.urlImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width > 720
          ? MediaQuery.of(context).size.height * 0.3
          : MediaQuery.of(context).size.height * 0.5,
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
