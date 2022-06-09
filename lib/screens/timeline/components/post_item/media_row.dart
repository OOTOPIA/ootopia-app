import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/timeline/media_model.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/multi_manager/flick_multi_manager.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/multi_manager/flick_multi_player.dart';
import 'package:ootopia_app/screens/timeline/components/image_post_timeline_component.dart';

class MediaRow extends StatelessWidget {
  final Function likePost;
  final FlickMultiManager flickMultiManager;
  final TimelinePost post;
  final String? userId;
  final Media media;
  const MediaRow({Key? key,
    required this.media,
    required this.likePost,
    required this.flickMultiManager,
    required this.post,
    required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (media.type == "image") {
      return ImagePostTimeline(
        image: media.mediaUrl as String,
        onDoubleTapVideo: likePost,
      );
    } else if (media.type == "video") {
      return FlickMultiPlayer(
        userId: userId ,
        postId: post.id,
        url: media.mediaUrl!,
        flickMultiManager: flickMultiManager,
        image: media.thumbUrl!,
        onDoubleTapVideo: likePost,
      );
    }else{
      return Container();
    }
  }

}
