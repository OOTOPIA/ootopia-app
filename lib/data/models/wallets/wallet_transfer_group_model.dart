import 'package:equatable/equatable.dart';
import 'package:ootopia_app/data/models/wallets/wallet_transfer_model.dart';

class WalletTransferGroup extends Equatable {
  final String date;
  final List<WalletTransfer> transfers;

  WalletTransferGroup({required this.date, required this.transfers});

  @override
  List<Object> get props => [
        date,
        transfers,
      ];
}
