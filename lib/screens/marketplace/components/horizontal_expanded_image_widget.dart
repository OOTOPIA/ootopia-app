import 'package:flutter/material.dart';

class HorizontalExpandedImageWidget extends StatelessWidget {
  final String urlImage;
  const HorizontalExpandedImageWidget({required this.urlImage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Image.network(
            urlImage,
          ),
        )
      ],
    );
  }
}
