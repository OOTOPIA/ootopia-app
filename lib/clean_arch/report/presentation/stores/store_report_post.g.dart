// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_report_post.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StoreReportPost on StoreReportPostBase, Store {
  final _$spamAtom = Atom(name: 'StoreReportPostBase.spam');

  @override
  bool get spam {
    _$spamAtom.reportRead();
    return super.spam;
  }

  @override
  set spam(bool value) {
    _$spamAtom.reportWrite(value, super.spam, () {
      super.spam = value;
    });
  }

  final _$nudezAtom = Atom(name: 'StoreReportPostBase.nudez');

  @override
  bool get nudez {
    _$nudezAtom.reportRead();
    return super.nudez;
  }

  @override
  set nudez(bool value) {
    _$nudezAtom.reportWrite(value, super.nudez, () {
      super.nudez = value;
    });
  }

  final _$violenceAtom = Atom(name: 'StoreReportPostBase.violence');

  @override
  bool get violence {
    _$violenceAtom.reportRead();
    return super.violence;
  }

  @override
  set violence(bool value) {
    _$violenceAtom.reportWrite(value, super.violence, () {
      super.violence = value;
    });
  }

  final _$otherAtom = Atom(name: 'StoreReportPostBase.other');

  @override
  bool get other {
    _$otherAtom.reportRead();
    return super.other;
  }

  @override
  set other(bool value) {
    _$otherAtom.reportWrite(value, super.other, () {
      super.other = value;
    });
  }

  final _$errorAtom = Atom(name: 'StoreReportPostBase.error');

  @override
  String get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  final _$successAtom = Atom(name: 'StoreReportPostBase.success');

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  final _$seeMorePostsAboutThisUserAtom =
      Atom(name: 'StoreReportPostBase.seeMorePostsAboutThisUser');

  @override
  bool get seeMorePostsAboutThisUser {
    _$seeMorePostsAboutThisUserAtom.reportRead();
    return super.seeMorePostsAboutThisUser;
  }

  @override
  set seeMorePostsAboutThisUser(bool value) {
    _$seeMorePostsAboutThisUserAtom
        .reportWrite(value, super.seeMorePostsAboutThisUser, () {
      super.seeMorePostsAboutThisUser = value;
    });
  }

  final _$sendReportAsyncAction = AsyncAction('StoreReportPostBase.sendReport');

  @override
  Future<void> sendReport({required String idUser, required String idPost}) {
    return _$sendReportAsyncAction
        .run(() => super.sendReport(idUser: idUser, idPost: idPost));
  }

  @override
  String toString() {
    return '''
spam: ${spam},
nudez: ${nudez},
violence: ${violence},
other: ${other},
error: ${error},
success: ${success},
seeMorePostsAboutThisUser: ${seeMorePostsAboutThisUser}
    ''';
  }
}
