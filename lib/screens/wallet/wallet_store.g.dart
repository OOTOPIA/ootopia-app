// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WalletStore on _WalletStoreBase, Store {
  final _$mapSumDaysTransferAtom =
      Atom(name: '_WalletStoreBase.mapSumDaysTransfer');

  @override
  Map<String, double> get mapSumDaysTransfer {
    _$mapSumDaysTransferAtom.reportRead();
    return super.mapSumDaysTransfer;
  }

  @override
  set mapSumDaysTransfer(Map<String, double> value) {
    _$mapSumDaysTransferAtom.reportWrite(value, super.mapSumDaysTransfer, () {
      super.mapSumDaysTransfer = value;
    });
  }

  final _$allGroupedTransfersByDateAtom =
      Atom(name: '_WalletStoreBase.allGroupedTransfersByDate');

  @override
  Map<String, List<WalletTransfer>>? get allGroupedTransfersByDate {
    _$allGroupedTransfersByDateAtom.reportRead();
    return super.allGroupedTransfersByDate;
  }

  @override
  set allGroupedTransfersByDate(Map<String, List<WalletTransfer>>? value) {
    _$allGroupedTransfersByDateAtom
        .reportWrite(value, super.allGroupedTransfersByDate, () {
      super.allGroupedTransfersByDate = value;
    });
  }

  final _$sentGroupedTransfersByDateAtom =
      Atom(name: '_WalletStoreBase.sentGroupedTransfersByDate');

  @override
  Map<String, List<WalletTransfer>>? get sentGroupedTransfersByDate {
    _$sentGroupedTransfersByDateAtom.reportRead();
    return super.sentGroupedTransfersByDate;
  }

  @override
  set sentGroupedTransfersByDate(Map<String, List<WalletTransfer>>? value) {
    _$sentGroupedTransfersByDateAtom
        .reportWrite(value, super.sentGroupedTransfersByDate, () {
      super.sentGroupedTransfersByDate = value;
    });
  }

  final _$receivedGroupedTransfersByDateAtom =
      Atom(name: '_WalletStoreBase.receivedGroupedTransfersByDate');

  @override
  Map<String, List<WalletTransfer>>? get receivedGroupedTransfersByDate {
    _$receivedGroupedTransfersByDateAtom.reportRead();
    return super.receivedGroupedTransfersByDate;
  }

  @override
  set receivedGroupedTransfersByDate(Map<String, List<WalletTransfer>>? value) {
    _$receivedGroupedTransfersByDateAtom
        .reportWrite(value, super.receivedGroupedTransfersByDate, () {
      super.receivedGroupedTransfersByDate = value;
    });
  }

  final _$walletIsEmptyAtom = Atom(name: '_WalletStoreBase.walletIsEmpty');

  @override
  bool get walletIsEmpty {
    _$walletIsEmptyAtom.reportRead();
    return super.walletIsEmpty;
  }

  @override
  set walletIsEmpty(bool value) {
    _$walletIsEmptyAtom.reportWrite(value, super.walletIsEmpty, () {
      super.walletIsEmpty = value;
    });
  }

  final _$walletAtom = Atom(name: '_WalletStoreBase.wallet');

  @override
  Wallet? get wallet {
    _$walletAtom.reportRead();
    return super.wallet;
  }

  @override
  set wallet(Wallet? value) {
    _$walletAtom.reportWrite(value, super.wallet, () {
      super.wallet = value;
    });
  }

  final _$getWalletTransfersHistoryAsyncAction =
      AsyncAction('_WalletStoreBase.getWalletTransfersHistory');

  @override
  Future<dynamic> getWalletTransfersHistory(int offset,
      [String? walletTransferAction]) {
    return _$getWalletTransfersHistoryAsyncAction.run(
        () => super.getWalletTransfersHistory(offset, walletTransferAction));
  }

  @override
  String toString() {
    return '''
mapSumDaysTransfer: ${mapSumDaysTransfer},
allGroupedTransfersByDate: ${allGroupedTransfersByDate},
sentGroupedTransfersByDate: ${sentGroupedTransfersByDate},
receivedGroupedTransfersByDate: ${receivedGroupedTransfersByDate},
walletIsEmpty: ${walletIsEmpty},
wallet: ${wallet}
    ''';
  }
}
