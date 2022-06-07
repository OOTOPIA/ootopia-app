import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/camera_screen/custom_gallery/components/media_view_widget.dart';

class ListOfMidias extends StatefulWidget {
  final Map<String, dynamic> args;
  const ListOfMidias({Key? key, required this.args}) : super(key: key);

  @override
  State<ListOfMidias> createState() => _ListOfMidiasState();
}

class _ListOfMidiasState extends State<ListOfMidias> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...widget.args['fileList'].map(buildMediaRow).toList(),
        ],
      ),
    );
  }

  void changeMediaFile(File newImage, var oldImage) {
    int index = widget.args['fileList']
        .indexWhere((element) => element['mediaId'] == oldImage['mediaId']);

    widget.args['fileList'][index]['mediaFile'] = newImage;
  }

  Widget buildMediaRow(dynamic file) {
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      height: MediaQuery.of(context).size.width - 60,
      child: MediaViewWidget(
        mediaFilePath: file['mediaFile'].path,
        mediaType: file['mediaType'],
        mediaSize: file['mediaSize'],
        shouldCustomFlickManager: true,
        showCropWidget: true,
        onChanged: (value) {
          changeMediaFile(value, file);
        },
      ),
    );
  }
}
