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

  final _$getUserTransactionHistoryAsyncAction =
      AsyncAction('_WalletStoreBase.getUserTransactionHistory');

  @override
  Future<Map<String, List<WalletTransfer>>> getUserTransactionHistory(
      [String? typeTransaction]) {
    return _$getUserTransactionHistoryAsyncAction
        .run(() => super.getUserTransactionHistory(typeTransaction));
  }

  @override
  String toString() {
    return '''
mapSumDaysTransfer: ${mapSumDaysTransfer},
wallet: ${wallet}
    ''';
  }
}
