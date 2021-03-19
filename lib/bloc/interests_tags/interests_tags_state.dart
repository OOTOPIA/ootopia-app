part of 'interests_tags_bloc.dart';

abstract class InterestsTagsState extends Equatable {
  const InterestsTagsState();
}

class EmptyState extends InterestsTagsState {
  @override
  List<Object> get props => null;
}

class InitialState extends InterestsTagsState {
  const InitialState();
  @override
  List<Object> get props => [];
}

class LoadingState extends InterestsTagsState {
  const LoadingState();
  @override
  List<Object> get props => [];
}

class LoadedSucessState extends InterestsTagsState {
  List<InterestsTags> tags;
  LoadedSucessState(this.tags);
  @override
  List<Object> get props => [tags];
}

class ErrorState extends InterestsTagsState {
  final String message;
  const ErrorState(this.message);
  @override
  List<Object> get props => [message];
}
