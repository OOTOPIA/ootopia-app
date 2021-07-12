// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_timeline_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PostTimelineController on PostTimelineControllerBase, Store {
  final _$postAtom = Atom(name: 'PostTimelineControllerBase.post');

  @override
  TimelinePost get post {
    _$postAtom.reportRead();
    return super.post;
  }

  @override
  set post(TimelinePost value) {
    _$postAtom.reportWrite(value, super.post, () {
      super.post = value;
    });
  }

  final _$likePostAsyncAction =
      AsyncAction('PostTimelineControllerBase.likePost');

  @override
  Future<LikePostResult> likePost() {
    return _$likePostAsyncAction.run(() => super.likePost());
  }

  @override
  String toString() {
    return '''
post: ${post}
    ''';
  }
}
