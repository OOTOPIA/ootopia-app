part of 'interests_tags_bloc.dart';

abstract class InterestsTagsEvent extends Equatable {
  const InterestsTagsEvent();
}

class GetTagsEvent extends InterestsTagsEvent {
  final String language;

  GetTagsEvent({required this.language});

  @override
  List<Object> get props => [];
}

class GetSucessTagsEvent extends InterestsTagsEvent {
  @override
  List<Object> get props => [];
}
