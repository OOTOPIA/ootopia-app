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

  final _$outherAtom = Atom(name: 'StoreReportPostBase.outher');

  @override
  bool get outher {
    _$outherAtom.reportRead();
    return super.outher;
  }

  @override
  set outher(bool value) {
    _$outherAtom.reportWrite(value, super.outher, () {
      super.outher = value;
    });
  }

  @override
  String toString() {
    return '''
spam: ${spam},
nudez: ${nudez},
violence: ${violence},
outher: ${outher}
    ''';
  }
}
