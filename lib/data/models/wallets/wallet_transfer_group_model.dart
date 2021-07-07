import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/data/models/wallets/wallet_transfer_model.dart';

class WalletTransferGroup extends Equatable {
  String date;
  List<WalletTransfer> transfers;

  WalletTransferGroup({required this.date, required this.transfers});

  @override
  List<Object> get props => [
        date,
        transfers,
      ];
}
