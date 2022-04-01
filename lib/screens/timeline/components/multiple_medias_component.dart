import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/timeline/media_model.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/multi_manager/flick_multi_manager.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/multi_manager/flick_multi_player.dart';
import 'package:ootopia_app/screens/timeline/components/image_post_timeline_component.dart';

class MultipleMediasComponent extends StatefulWidget {
  final TimelinePost post;
  final User? user;
  final FlickMultiManager? flickMultiManager;
  final Function(bool, bool) likePost;
  const MultipleMediasComponent({
    Key? key,
    required this.post,
    this.user,
    this.flickMultiManager,
    required this.likePost,
  }) : super(key: key);

  @override
  State<MultipleMediasComponent> createState() =>
      _MultipleMediasComponentState();
}

class _MultipleMediasComponentState extends State<MultipleMediasComponent> {
  bool showPosition = false;
  int mediaPosition = 0;

  @override
  Widget build(BuildContext context) {
    print('MULTIPLE MEDIAS CHAMADO');
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          child: PageView.builder(
            itemCount: widget.post.medias!.length,
            pageSnapping: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, pagePosition) {
              return buildMediaRow(widget.post.medias![pagePosition]);
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
        ),
        if (widget.post.type == 'gallery' &&
            widget.post.medias!.length > 1 &&
            showPosition)
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
      ],
    );
  }

  buildMediaRow(Media media) {
    if (media.type == "image") {
      return ImagePostTimeline(
        image: media.mediaUrl as String,
        onDoubleTapVideo: () => widget.likePost(false, true),
      );
    } else if (media.type == "video") {
      return FlickMultiPlayer(
        userId: (widget.user != null ? widget.user!.id : null),
        postId: widget.post.id,
        url: media.mediaUrl!,
        flickMultiManager: widget.flickMultiManager!,
        image: media.thumbUrl!,
        onDoubleTapVideo: () => widget.likePost(false, true),
      );
    }
  }
}
