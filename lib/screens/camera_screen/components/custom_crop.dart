import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class CustomCrop extends StatefulWidget {
  final File image;
  final ValueChanged<File>? onChanged;
  final bool? fromCamera;
  const CustomCrop({
    Key? key,
    required this.image,
    this.onChanged,
    this.fromCamera = false,
  }) : super(key: key);

  @override
  State<CustomCrop> createState() => _CustomCropState();
}

class _CustomCropState extends State<CustomCrop> {
  final _controller = CropController();
  var imageData;
  Uint8List? _croppedData;
  @override
  void initState() {
    super.initState();
    imageData = fileToBytes();
  }

  var _isProcessing = false;
  set isProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  set croppedData(Uint8List? value) {
    _croppedData = value;
    saveFileOnDirectory(_croppedData);
  }

  fileToBytes() {
    Uint8List bytes = widget.image.readAsBytesSync();
    return bytes;
  }

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
                child: Crop(
                  controller: _controller,
                  image: imageData,
                  baseColor: Colors.black,
                  onCropped: (cropped) {
                    croppedData = cropped;
                    isProcessing = false;
                  },
                ),
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
                    _isProcessing
                        ? Center(child: CircularProgressIndicator())
                        : TextButton(
                            child: Text(
                              AppLocalizations.of(context)?.cropButton ?? "",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () => _cropImage(),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    isProcessing = true;
    _controller.crop();
  }

  saveFileOnDirectory(Uint8List? imageBytes) async {
    String appPath = (await getApplicationDocumentsDirectory()).path;
    File newFile = File('$appPath/${imageBytes.hashCode}.png');
    await newFile.writeAsBytes(imageBytes!.toList());

    if (widget.onChanged != null) widget.onChanged!(newFile);

    handleNavigation(newFile);
  }

  handleNavigation(File file) {
    if (widget.fromCamera!) {
      Navigator.of(this.context).pushNamed(
        PageRoute.Page.postPreviewScreen.route,
        arguments: {"filePath": file.path, "type": "image"},
      );
    } else
      Navigator.pop(context);
  }
}
