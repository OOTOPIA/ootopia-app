import 'dart:io';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomCrop extends StatefulWidget {
  final File image;
  final ValueChanged<Image> onChanged;
  const CustomCrop({Key? key, required this.image, required this.onChanged})
      : super(key: key);

  @override
  State<CustomCrop> createState() => _CustomCropState();
}

class _CustomCropState extends State<CustomCrop> {
  final controller = CropController(
    aspectRatio: 1,
    defaultCrop: Rect.fromLTRB(0.0, 0.0, 1, 1),
  );

  late Image newCroppedImage;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.black,
                padding: const EdgeInsets.all(20.0),
                child: _buildCropImage(controller),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(top: 20.0),
                alignment: AlignmentDirectional.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    TextButton(
                      child: Text(
                        AppLocalizations.of(context)?.cropButton ?? "",
                        style: Theme.of(context).textTheme.button,
                      ),
                      onPressed: () => _cropImage(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildCropImage(controller) {
    return CropImage(
      controller: controller,
      image: Image(image: FileImage(widget.image)),
    );
  }

  Future<void> _cropImage() async {
    newCroppedImage = await controller.croppedImage();
    widget.onChanged(newCroppedImage);
    Navigator.pop(context);
  }
}
