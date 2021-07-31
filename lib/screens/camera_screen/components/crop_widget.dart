import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';

class CropWidget extends StatelessWidget {
  final cropKey = GlobalKey<CropState>();
  File imageFile;

  CropWidget({Key? key, required this.imageFile}) : super(key: key);

  Widget _buildCropImage() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(20.0),
      child: Crop(
        key: cropKey,
        image: FileImage(imageFile),
        aspectRatio: 1 / 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(20.0),
        child: _buildCropImage(),
      ),
    );
  }
}
