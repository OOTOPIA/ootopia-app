import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ootopia_app/data/models/timeline_post_model.dart';
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
    if (event is LoadingSucessTimelinePostEvent) {
      yield* _mapAlbumsLoadedToState();
    } // else if (event is CreateTimelinePostEvent) {
    //   yield* _mapAlbumAddedToState(event);
    // } else if (event is UpdateTimelinePostEvent) {
    //   yield* _mapAlbumUpdatedToState(event);
    // } else if (event is DeleteTimelinePostEvent) {
    //   yield* _mapAlbumDeletedToState(event);
    // }
  }

  Stream<TimelinePostState> _mapAlbumsLoadedToState() async* {
    try {
      var posts = (await this.repository.getPosts());
      yield LoadedSucessState(posts);
    } catch (_) {
      yield ErrorState("error loading Albums");
    }
  }

  // Stream<TimelinePostState> _mapAlbumAddedToState(CreateTimelinePostEvent event) async* {
  //   try {
  //     if (state is LoadedSucessState) {
  //       var newAlbum = (await this.repository.createAlbum(event.album));
  //       List<Album> updatedAlbums;
  //       if (newAlbum != null) {
  //         updatedAlbums = List.from((state as LoadedSucessState).album)
  //           ..add(newAlbum);

  //         yield LoadedSucessState(updatedAlbums.reversed.toList());
  //       }
  //     }
  //   } catch (_) {
  //     yield ErrorState("error Add Album");
  //   }
  // }

  // Stream<TimelinePostState> _mapAlbumUpdatedToState(UpdateTimelinePostEvent event) async* {
  //   try {
  //     if (state is LoadedSucessState) {
  //       var updatedAlbum = (await this.repository.updateAlbum(event.album));
  //       if (updatedAlbum != null) {
  //         final List<Album> updatedAlbums =
  //             (state as LoadedSucessState).album.map((album) {
  //           return album.id == updatedAlbum.id ? updatedAlbum : album;
  //         }).toList();

  //         yield LoadedSucessState(updatedAlbums);
  //       }
  //     }
  //   } catch (_) {
  //     yield ErrorState("error update album");
  //   }
  // }

  // Stream<TimelinePostState> _mapAlbumDeletedToState(DeleteTimelinePostEvent event) async* {
  //   try {
  //     if (state is LoadedSucessState) {
  //       final deletelbum = (state as LoadedSucessState)
  //           .album
  //           .where((album) => album.id != event.album.id)
  //           .toList();
  //       yield LoadedSucessState(deletelbum);
  //     }
  //   } catch (_) {
  //     yield ErrorState("error delete album");
  //   }
  // }
}
