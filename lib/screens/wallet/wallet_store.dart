import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/wallets/wallet_model.dart';
import 'package:ootopia_app/data/models/wallets/wallet_transfer_model.dart';
import 'package:ootopia_app/data/repositories/wallet_repository.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:collection/collection.dart';

part 'wallet_store.g.dart';

class WalletStore = _WalletStoreBase with _$WalletStore;

abstract class _WalletStoreBase with Store {
  WalletRepositoryImpl walletRepositoryImpl = WalletRepositoryImpl();
  Map<String, double> mapSumDaysTransfer = {};
  Future<Map<String, List<WalletTransfer>>> getUserTransactionHistory(
      [String? typeTransaction]) async {
    AuthStore authStore = AuthStore();
    var authId = await authStore.checkUserIsLogged();
    var resultTransactions = await walletRepositoryImpl.getTransactionHistory(
        50, 0, authId!.id, typeTransaction);
    var map = groupBy(
        resultTransactions,
        (WalletTransfer obj) => DateFormat('MMM d, y')
            .format(DateTime.parse(obj.createdAt))
            .toString());
    map.entries.forEach((element) {
      var soma = 0.0;
      element.value.forEach((element) {
        soma = element.balance + soma;
      });
      mapSumDaysTransfer.addAll({element.key: soma});
    });

    return map;
  }

  Future<Wallet> getBalanceUser() async {
    AuthStore authStore = AuthStore();
    var authId = await authStore.checkUserIsLogged();
    return await walletRepositoryImpl.getWallet(authId!.id.toString());
  }
}
