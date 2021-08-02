import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';

import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class CropWidget extends StatefulWidget {
  File imageFile;
  bool? mirroredPhoto;

  CropWidget({
    Key? key,
    required this.imageFile,
    this.mirroredPhoto,
  }) : super(key: key);

  @override
  _CropWidgetState createState() => _CropWidgetState();
}

class _CropWidgetState extends State<CropWidget> {
  final cropKey = GlobalKey<CropState>();
  File? _sample;
  File? _lastCropped;

  @override
  void dispose() {
    super.dispose();
    _sample?.delete();
    _lastCropped?.delete();
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState!.scale;
    final area = cropKey.currentState!.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
      file: widget.imageFile,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    sample.delete();

    _lastCropped?.delete();
    _lastCropped = file;

    await Navigator.of(this.context).pushNamed(
      PageRoute.Page.postPreviewScreen.route,
      arguments: {
        "filePath": file.path,
        "mirrored": widget.mirroredPhoto.toString(),
        "type": "image"
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildCropImage(),
          Container(
            padding: const EdgeInsets.only(top: 20.0),
            alignment: AlignmentDirectional.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                  child: Text(
                    'Crop Image',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () => _cropImage(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCropImage() {
    return Expanded(
      child: Crop(
        key: cropKey,
        image: FileImage(widget.imageFile),
      ),
    );
  }
}
