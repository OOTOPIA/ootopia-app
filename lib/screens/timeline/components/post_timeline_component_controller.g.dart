// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_timeline_component_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PostTimelineComponentController
    on _PostTimelineComponentControllerBase, Store {
  final _$askToConfirmGratitudeAtom =
      Atom(name: '_PostTimelineComponentControllerBase.askToConfirmGratitude');

  @override
  bool get askToConfirmGratitude {
    _$askToConfirmGratitudeAtom.reportRead();
    return super.askToConfirmGratitude;
  }

  @override
  set askToConfirmGratitude(bool value) {
    _$askToConfirmGratitudeAtom.reportWrite(value, super.askToConfirmGratitude,
        () {
      super.askToConfirmGratitude = value;
    });
  }

  final _$_PostTimelineComponentControllerBaseActionController =
      ActionController(name: '_PostTimelineComponentControllerBase');

  @override
  void setAskToConfirmGratitude(bool value) {
    final _$actionInfo =
        _$_PostTimelineComponentControllerBaseActionController.startAction(
            name:
                '_PostTimelineComponentControllerBase.setAskToConfirmGratitude');
    try {
      return super.setAskToConfirmGratitude(value);
    } finally {
      _$_PostTimelineComponentControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
askToConfirmGratitude: ${askToConfirmGratitude}
    ''';
  }
}
