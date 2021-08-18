// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TimelineProfileStore on _TimelineProfileStoreBase, Store {
  final _$postsAtom = Atom(name: '_TimelineProfileStoreBase.posts');

  @override
  List<TimelinePost> get posts {
    _$postsAtom.reportRead();
    return super.posts;
  }

  @override
  set posts(List<TimelinePost> value) {
    _$postsAtom.reportWrite(value, super.posts, () {
      super.posts = value;
    });
  }

  final _$postAtom = Atom(name: '_TimelineProfileStoreBase.post');

  @override
  TimelinePost? get post {
    _$postAtom.reportRead();
    return super.post;
  }

  @override
  set post(TimelinePost? value) {
    _$postAtom.reportWrite(value, super.post, () {
      super.post = value;
    });
  }

  final _$getPostByIdAsyncAction =
      AsyncAction('_TimelineProfileStoreBase.getPostById');

  @override
  Future<TimelinePost> getPostById(String id) {
    return _$getPostByIdAsyncAction.run(() => super.getPostById(id));
  }

  @override
  String toString() {
    return '''
posts: ${posts},
post: ${post}
    ''';
  }
}
