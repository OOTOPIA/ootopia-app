import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class KKkk extends StatefulWidget {
  KKkk({Key? key}) : super(key: key);

  @override
  TesteDoteste createState() => TesteDoteste();
}

class TesteDoteste extends State<KKkk> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  // setState(() {});
  @override
  void initState() {
    _controller =
        VideoPlayerController.asset('assets/videos/ootopia_celebration.mp4')
          ..initialize().then((_) {
            setState(() {
              _controller.play();
            });
          });
    // 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(false);

    setState(() {});

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('widget.title'),
        ),
        body: Container(
            child: Stack(
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return Center(
                      child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: VideoPlayer(_controller),
                  ));
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                              child: Text(
                                "Congratulations!".toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                    color: Color(0xFF003694)),
                              )),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Text(
                                'Luiz Reais'.toLowerCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Color(0xFF000000)),
                              )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Text(
                              'You met your daily goal to help regenerate the planet',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF000000)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black)),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 0, 0),
                                        child: Text(
                                          "you received",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                              color: Color(0xFF000000)),
                                        )),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 20, 0),
                                        child: Text(
                                          "17,55",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                              color: Color(0xFF000000)),
                                        ))
                                  ],
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Column(
                              children: [
                                Text(
                                  "Next step is to help meet your city goal.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Color(0xFF000000)),
                                ),
                                Text(
                                  "Keep making OOTOPIA alive!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF000000)),
                                )
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  child: TextButton(
                                    style: ButtonStyle(
                                        alignment: Alignment.center,
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color(0xFF003694)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ))),
                                    child: Text(
                                      "Go On!",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () => {},
                                  )))
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        )));
  }
}
