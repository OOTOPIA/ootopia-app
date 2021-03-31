import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/multi_manager/flick_multi_manager.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class PostPreviewPage extends StatefulWidget {
  Map<String, dynamic> args;
  PostPreviewPage(this.args);

  @override
  _PostPreviewPageState createState() => _PostPreviewPageState();
}

class Animal {
  final int id;
  final String name;

  Animal({
    this.id,
    this.name,
  });
}

class _PostPreviewPageState extends State<PostPreviewPage> {
  FlickManager flickManager;
  VideoPlayerController videoPlayer;
  FlickMultiManager flickMultiManager;

  final _multiSelectKey = GlobalKey<FormFieldState>();

  static List<Animal> _animals = [
    Animal(id: 1, name: "Lion"),
    Animal(id: 2, name: "Flamingo"),
    Animal(id: 3, name: "Hippo"),
    Animal(id: 4, name: "Horse"),
    Animal(id: 5, name: "Tiger"),
    Animal(id: 6, name: "Penguin"),
    Animal(id: 7, name: "Spider"),
    Animal(id: 8, name: "Snake"),
    Animal(id: 9, name: "Bear"),
    Animal(id: 10, name: "Beaver"),
    Animal(id: 11, name: "Cat"),
    Animal(id: 12, name: "Fish"),
    Animal(id: 13, name: "Rabbit"),
    Animal(id: 14, name: "Mouse"),
    Animal(id: 15, name: "Dog"),
    Animal(id: 16, name: "Zebra"),
    Animal(id: 17, name: "Cow"),
    Animal(id: 18, name: "Frog"),
    Animal(id: 19, name: "Blue Jay"),
    Animal(id: 20, name: "Moose"),
    Animal(id: 21, name: "Gecko"),
    Animal(id: 22, name: "Kangaroo"),
    Animal(id: 23, name: "Shark"),
    Animal(id: 24, name: "Crocodile"),
    Animal(id: 25, name: "Owl"),
    Animal(id: 26, name: "Dragonfly"),
    Animal(id: 27, name: "Dolphin"),
  ];

  final _items = _animals
      .map((animal) => MultiSelectItem<Animal>(animal, animal.name))
      .toList();

  List<Animal> _selectedAnimals = [];

  @override
  void initState() {
    super.initState();

    flickMultiManager = FlickMultiManager();
    videoPlayer = VideoPlayerController.file(File(widget.args["filePath"]));

    flickManager = FlickManager(
      videoPlayerController: videoPlayer,
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Post',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffC0D9E8),
                Color(0xffffffff),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(GlobalConstants.of(context).spacingSmall),
          child: Column(
            children: [
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * .6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: FlickVideoPlayer(
                      preferredDeviceOrientationFullscreen: [],
                      flickManager: flickManager,
                      flickVideoWithControls: FlickVideoWithControls(
                        controls: PlayerControls(
                          flickMultiManager: flickMultiManager,
                          flickManager: flickManager,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              TextFormField(
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                autofocus: false,
                decoration: InputDecoration(
                  hintText: "Write a description",
                  hintStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 1.5),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 1.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1.5),
                  ),
                ),
                onChanged: (String val) {},
              ),
              SizedBox(
                height: GlobalConstants.of(context).spacingNormal,
              ),
              MultiSelectDialogField(
                key: _multiSelectKey,
                listType: MultiSelectListType.CHIP,
                selectedColor: Colors.blue,
                selectedItemsTextStyle: TextStyle(color: Colors.white),
                searchable: true,
                searchTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  border: Border.all(
                    color: Colors.black54,
                    width: 2,
                  ),
                ),
                buttonIcon: Icon(
                  Icons.add,
                  color: Colors.black54,
                ),
                title: Text(
                  "Select at least 3 tags",
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                buttonText: Text(
                  "Select tags",
                ),
                items: _items,
                onConfirm: (values) {
                  setState(() {
                    _selectedAnimals = [];
                    values.forEach((v) {
                      _selectedAnimals.add(v);
                    });
                  });
                  _multiSelectKey.currentState.validate();
                },
                chipDisplay: MultiSelectChipDisplay(
                  onTap: (value) {
                    setState(() {
                      _selectedAnimals.remove(value);
                    });
                    _multiSelectKey.currentState.validate();
                  },
                ),
              ),
              _selectedAnimals.length == 0
                  ? Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "No tags selected",
                        style: TextStyle(color: Colors.black54),
                      ))
                  : Container(),
              SizedBox(
                height: GlobalConstants.of(context).spacingNormal,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff73d778),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: FlatButton(
                  child: Padding(
                    padding: EdgeInsets.all(
                      GlobalConstants.of(context).spacingNormal,
                    ),
                    child: Text(
                      "Send post",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  onPressed: () {},
                  splashColor: Colors.black54,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Color(0xff73d778),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayerControls extends StatelessWidget {
  const PlayerControls(
      {Key key, this.flickMultiManager, this.flickManager, this.filePath})
      : super(key: key);

  final FlickMultiManager flickMultiManager;
  final FlickManager flickManager;
  final String filePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlickAutoHideChild(
            showIfVideoNotInitialized: false,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FlickLeftDuration(),
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FlickAutoHideChild(
              autoHide: false,
              showIfVideoNotInitialized: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // Container(
                  //   padding: EdgeInsets.all(2),
                  //   decoration: BoxDecoration(
                  //     color: Colors.black38,
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   child: FlickSoundToggle(
                  //     toggleMute: () => flickMultiManager.toggleMute(),
                  //     color: Colors.white,
                  //   ),
                  // ),
                  IconButton(
                    icon: const Icon(Icons.fullscreen),
                    tooltip: 'Increase volume by 10',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  // FlickFullScreenToggle(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
