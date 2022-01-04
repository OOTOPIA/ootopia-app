import 'dart:async';

import 'package:flutter/material.dart';

class VideoBar extends StatefulWidget {
  String totalTimeVideoText;
  String positionVideoText;
  int currentPosition;
  double maxDurationVideo;
  Timer? timerOpacity;
  Function onChangeStart;
  Function onChanged;
  Function onChangeEnd;
  Function fullScreenEvent;
  bool fullScreenVideo;

  VideoBar({
    Key? key,
    required this.totalTimeVideoText,
    required this.positionVideoText,
    required this.currentPosition,
    required this.maxDurationVideo,
    this.timerOpacity,
    required this.fullScreenEvent,
    required this.onChangeStart,
    required this.onChanged,
    required this.onChangeEnd,
    required this.fullScreenVideo,
  }) : super(key: key);

  @override
  _VideoBarState createState() => _VideoBarState();
}

class _VideoBarState extends State<VideoBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.timerOpacity != null ? 1 : 0.0,
      duration: Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.timerOpacity?.cancel();
            widget.timerOpacity = Timer(
              Duration(seconds: 1),
              () => setState(() => widget.timerOpacity = null),
            );
          });
        },
        child: Container(
          height: 40,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${widget.positionVideoText}',
                style: TextStyle(
                  color: Color(0xffCDCDCD),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.5),
                    trackShape: CustomTrackShape(),
                  ),
                  child: Slider(
                    inactiveColor: Color(0xffCDCDCD),
                    activeColor: Color(0xff35ad6c),
                    thumbColor: Color(0xff35ad6c),
                    min: 0,
                    max: widget.maxDurationVideo,
                    value: widget.currentPosition.toDouble(),
                    onChangeStart: (value) => widget.onChangeStart(value),
                    onChanged: (value) => widget.onChanged(value),
                    onChangeEnd: (value) => widget.onChangeEnd(value),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '${widget.totalTimeVideoText}',
                style: TextStyle(
                  color: Color(0xffCDCDCD),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: () {
                  widget.fullScreenEvent();
                },
                icon: widget.fullScreenVideo
                    ? ImageIcon(
                        AssetImage("assets/icons/icon_minimizescreen.png"),
                        color: Color(0xFFCDCDCD),
                        size: 16)
                    : ImageIcon(
                        AssetImage("assets/icons/icon_maximizescreen.png"),
                        color: Color(0xFFCDCDCD),
                        size: 16),
              ),
              Text(
                '${widget.totalTimeVideoText}',
                style: TextStyle(
                  color: Color(0xffCDCDCD),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
