import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'package:ootopia_app/data/repositories/interests_tags_repository.dart';

part 'interests_tags_event.dart';
part 'interests_tags_state.dart';

class InterestsTagsBloc extends Bloc<InterestsTagsEvent, InterestsTagsState> {
  InterestsTagsRepositoryImpl repository = InterestsTagsRepositoryImpl();

  InterestsTagsBloc(this.repository) : super(LoadingState());

  InterestsTagsState get initialState => InitialState();

  @override
  Stream<InterestsTagsState> mapEventToState(
    InterestsTagsEvent event,
  ) async* {
    // Emitting a state from the asynchronous generator
    // Branching the executed logic by checking the event type
    LoadingState();
    if (event is GetTagsEvent) {
      yield LoadingState();
      yield* _mapGetInterestsTagsToState(event);
    } // else if (event is UpdateTimelinePostEvent) {
    //   yield* _mapAlbumUpdatedToState(event);
    // } else if (event is DeleteTimelinePostEvent) {
    //   yield* _mapAlbumDeletedToState(event);
    // }
  }

  Stream<InterestsTagsState> _mapGetInterestsTagsToState(
      GetTagsEvent event) async* {
    try {
      var tags = (await this.repository.getTags(event.language));
      yield LoadedSucessState(tags);
    } catch (_) {
      yield ErrorState("Error on load tags");
    }
  }
}
