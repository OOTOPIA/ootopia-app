import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/multi_manager/flick_multi_manager.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/multi_manager/flick_multi_player.dart';
import 'package:ootopia_app/screens/timeline/components/image_post_timeline_component.dart';
import 'package:ootopia_app/screens/timeline/components/post_item/media_row.dart';

class ShowMediaComponent extends StatefulWidget {
  final TimelinePost post;
  final User? user;
  final FlickMultiManager? flickMultiManager;
  final bool bigLikeShowAnimation;
  final bool bigLikeShowAnimationEnd;
  final bool canDoubleClick;
  final Function(bool, bool) likePost;
  const ShowMediaComponent({
    Key? key,
    required this.post,
    this.user,
    this.flickMultiManager,
    required this.bigLikeShowAnimation,
    required this.bigLikeShowAnimationEnd,
    required this.canDoubleClick,
    required this.likePost,
  }) : super(key: key);

  @override
  State<ShowMediaComponent> createState() => _ShowMediaComponent();
}

class _ShowMediaComponent extends State<ShowMediaComponent> {
  bool showPosition = false;
  int mediaPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Column(
              children: [
                if (widget.post.type == 'image') ...[
                  ImagePostTimeline(
                    image: widget.post.imageUrl as String,
                    onDoubleTapVideo: () => widget.likePost(false, true),
                  )
                ] else if (widget.post.type == 'video') ...[
                  FlickMultiPlayer(
                    userId: widget.user?.id,
                    postId: widget.post.id,
                    url: widget.post.videoUrl!,
                    flickMultiManager: widget.flickMultiManager!,
                    image: widget.post.thumbnailUrl!,
                    onDoubleTapVideo: () => widget.likePost(false, true),
                  )
                ] else ...[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                      itemCount: widget.post.medias!.length,
                      pageSnapping: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, pagePosition) {
                        return MediaRow(
                            media: widget.post.medias![pagePosition],
                            post: widget.post,
                            likePost: () => widget.likePost(false, true),
                            flickMultiManager: widget.flickMultiManager!,
                            userId: widget.user?.id);
                      },
                      onPageChanged: (value) {
                        setState(() {
                          mediaPosition = value;
                          showPosition = true;
                          Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              showPosition = false;
                            });
                          });
                        });
                      },
                    ),
                  )
                ]
              ],
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.center,
                child: AnimatedContainer(
                  height: widget.bigLikeShowAnimation &&
                          !widget.bigLikeShowAnimationEnd
                      ? 100
                      : 0.0,
                  width: widget.bigLikeShowAnimation &&
                          !widget.bigLikeShowAnimationEnd
                      ? 100
                      : 0.0,
                  curve: widget.bigLikeShowAnimation &&
                          !widget.bigLikeShowAnimationEnd &&
                          widget.canDoubleClick
                      ? Curves.easeOutBack
                      : Curves.easeIn,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedOpacity(
                    opacity: widget.bigLikeShowAnimation &&
                            !widget.bigLikeShowAnimationEnd
                        ? 0.8
                        : 0.0,
                    duration: Duration(milliseconds: 300),
                    child: Visibility(
                      visible: widget.bigLikeShowAnimation,
                      child: Image.asset(
                        'assets/icons_profile/woow_90_deg.png',
                        width: widget.bigLikeShowAnimation &&
                                !widget.bigLikeShowAnimationEnd
                            ? 100
                            : 0.0,
                        height: widget.bigLikeShowAnimation &&
                                !widget.bigLikeShowAnimationEnd
                            ? 100
                            : 0.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (isCarrousel() && showPosition) ...[
              Positioned(
                right: 23,
                top: 22,
                child: Container(
                  height: 20,
                  width: 35,
                  child: Center(
                    child: Text(
                      '${mediaPosition + 1}/${widget.post.medias!.length}',
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ]
          ],
        ),
        if (isCarrousel()) ...[
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: indexDots(widget.post.medias!.length),
          ),
        ],
      ],
    );
  }

  bool isCarrousel() {
    return widget.post.type == 'gallery' && widget.post.medias!.length > 1;
  }

  List<Widget> indexDots(int mediasLength) {
    return List<Widget>.generate(mediasLength, (index) {
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: mediaPosition == index ? Colors.blue[900] : Colors.black26,
          shape: BoxShape.circle,
        ),
      );
    });
  }
}
