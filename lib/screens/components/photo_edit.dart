import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class PhotoEdit extends StatefulWidget {
  String? photoUrl;
  String? photoPath;
  Function updatePhoto;

  PhotoEdit({
    this.photoUrl,
    this.photoPath,
    required this.updatePhoto,
  });

  @override
  _PhotoEditState createState() => _PhotoEditState();
}

class _PhotoEditState extends State<PhotoEdit> {
  XFile? file;
  String? filePath;
  final picker = ImagePicker();

  @override
  void initState() {
    if (widget.photoPath != null) {
      file = XFile(widget.photoPath!);
      filePath = file!.path;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 140,
          child: Column(
            children: [
              file == null
                  ? widget.photoUrl == null
                      ? CircleAvatar(
                          radius: 55,
                          child: Image.asset(
                            'assets/icons/user.png',
                          ),
                        )
                      : Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            border: new Border.all(
                              color: Colors.white,
                              width: 3.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundImage: NetworkImage(
                              widget.photoUrl.toString(),
                            ),
                          ),
                        )
                  : Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Colors.white,
                          width: 3.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: Image.file(
                          File(filePath!),
                          fit: BoxFit.cover,
                        ).image,
                      ),
                    ),
            ],
          ),
        ),
        Positioned(
          bottom: 5,
          right: file == null
              ? widget.photoUrl == null
                  ? 29
                  : 33
              : 33,
          child: InkWell(
            onTap: () async {
              // Pick an image
              final image = await picker.pickImage(source: ImageSource.gallery);

              final XFile xfile = XFile(image!.path);

              setState(() {
                file = xfile;
                filePath = xfile.path;
                widget.updatePhoto(file!.path);
              });
            },
            child: Container(
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: new Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Color(0xff03DAC5),
                radius: 22.5,
                child: SvgPicture.asset(
                  'assets/icons/camera.svg',
                  width: 20.78,
                  height: 17,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
