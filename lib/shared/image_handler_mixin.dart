import 'dart:async';
import 'package:flutter/material.dart';

mixin ImageHandler {
  Future<Size> _calculateImageDimension(String urlImage) {
    Completer<Size> completer = Completer();
    Image image = Image.network(urlImage);
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, _) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }

  Future<Size> getImageSize(String urlImage) async {
    final Size imageSize;
    imageSize = await _calculateImageDimension(urlImage);
    return imageSize;
  }

  bool isWidthGreaterThanHeight(Size size) => size.width > size.height;
}
