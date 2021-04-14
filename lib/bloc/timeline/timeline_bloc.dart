import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';

part 'timeline_event.dart';
part 'timeline_state.dart';

class TimelinePostBloc extends Bloc<TimelinePostEvent, TimelinePostState> {
  PostRepository repository;

  // TimelinePostBloc({@required PostRepository repository})
  //     : super(LoadingState()) {
  //   this.repository = repository;
  // }

  TimelinePostBloc(this.repository) : super(LoadingState());

  @override
  TimelinePostState get initialState => LoadingState();

  @override
  Stream<TimelinePostState> mapEventToState(
    TimelinePostEvent event,
  ) async* {
    // Emitting a state from the asynchronous generator
    // Branching the executed logic by checking the event type
    LoadingState();
    if (event is GetTimelinePostsEvent) {
      if (event.offset <= 0) {
        yield LoadingState();
      }
      yield* _mapGetTimelinePostsToState(event);
    } else if (event is LikePostEvent) {
      yield* _mapPostLikedToState(event);
    } else if (event is OnDeletePostFromTimelineEvent) {
      yield OnDeletedPostState(event.postId);
      yield LoadedSucessState([], true);
    }
  }

  Stream<TimelinePostState> _mapGetTimelinePostsToState(
      GetTimelinePostsEvent event) async* {
    try {
      var posts = (await this
          .repository
          .getPosts(event.limit, event.offset, event.userId));
      yield LoadedSucessState(posts, false);
    } catch (_) {
      yield ErrorState("Error loading posts");
    }
  }

  Stream<TimelinePostState> _mapPostLikedToState(LikePostEvent event) async* {
    try {
      if (state is LoadedSucessState) {
        var result = (await this.repository.likePost(event.postId));
        if (result != null) {
          final List<TimelinePost> posts =
              (state as LoadedSucessState).posts.map((post) {
            if (post.id == event.postId) {
              post.liked = result.liked;
              post.likesCount = result.count;
            }
            return post;
          }).toList();
          yield LoadingState();
          yield LoadedSucessState(posts, false);
        }
      }
    } catch (_) {
      yield ErrorState("error on like a post");
    }
  }
}
