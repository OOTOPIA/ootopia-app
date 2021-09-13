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

  @observable
  Map<String, double> mapSumDaysTransfer = {};

  @observable
  Map<String, List<WalletTransfer>>? allGroupedTransfersByDate;

  @observable
  Map<String, List<WalletTransfer>>? sentGroupedTransfersByDate;

  @observable
  Map<String, List<WalletTransfer>>? receivedGroupedTransfersByDate;

  @observable
  bool walletIsEmpty = false;

  @observable
  Wallet? wallet;

  @action
  Future getWalletTransfersHistory(int offset,
      [String? walletTransferAction]) async {
    var resultTransactions = await walletRepositoryImpl.getTransactionHistory(
        50, offset, walletTransferAction);
    var map = groupBy(
      resultTransactions,
      (WalletTransfer obj) => DateFormat('MMM d, y')
          .format(DateTime.parse(obj.createdAt))
          .toString(),
    );

    map.entries.forEach((element) {
      double soma = 0.00;
      element.value.forEach((element) {
        if (element.action == 'sent' &&
            element.origin != "invitation_code_sent") {
          soma -= element.balance;
        } else {
          soma += element.balance;
        }
      });
      mapSumDaysTransfer.addAll({element.key: soma});
    });

    if (walletTransferAction == "sent") {
      sentGroupedTransfersByDate = map;
    } else if (walletTransferAction == "received") {
      receivedGroupedTransfersByDate = map;
    } else {
      allGroupedTransfersByDate = map;
    }
    this.walletIsEmpty = map.entries.length == 0;
    return map;
  }

  Future<Wallet> getWallet() async {
    AuthStore authStore = AuthStore();
    var authId = await authStore.checkUserIsLogged();
    this.wallet = await walletRepositoryImpl.getWallet(authId!.id.toString());
    return this.wallet!;
  }
}
