import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import 'package:video_player/video_player.dart';

// import 'package:video_player/video_player.dart';

class TimelinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          PhotoTimeline(),
          PhotoTimeline(),
          PhotoTimeline(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        // currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        // onTap: _onItemTapped,
      ),
    );
  }
}

class PhotoTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Text(
            'Andrew Montes Teste Teste',
            textAlign: TextAlign.start,
          ),

          // Image.asset(
          //   'assets/images/teste01.jpeg',
          //   width: double.infinity,
          //   height: 400,
          //   fit: BoxFit.cover,
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.pink,
                        size: 24.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                    ),
                    Icon(
                      Icons.comment_outlined,
                      color: Colors.black,
                      size: 24.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ],
                ),
                Transform.rotate(
                  angle: 270 * pi / 180,
                  child: Icon(
                    Icons.label_important_outline,
                    color: Colors.black,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          )
        ],
      ),
    );
  }
}

class PlayerVideo extends StatefulWidget {
  @override
  _PlayerVideoState createState() => _PlayerVideoState();
}

class _PlayerVideoState extends State<PlayerVideo> {
  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(
                  child: Text(
                    'Video Nao carregado',
                  ),
                ),
        ),
        IconButton(
          icon: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
        )
      ],
    );
  }
}
