part of 'wallet_transfer_bloc.dart';

//@immutable
abstract class WalletTransferEvent extends Equatable {
  const WalletTransferEvent();
}

class LoadingGratitudeRewardEvent extends WalletTransferEvent {
  @override
  List<Object> get props => [];
}

class SendGratitudeRewardEvent extends WalletTransferEvent {
  final String postId;
  final double balance;
  final bool dontAskToConfirmAgain;
  const SendGratitudeRewardEvent(this.postId, this.balance,
      [this.dontAskToConfirmAgain]);
  @override
  List<Object> get props => [postId, balance, dontAskToConfirmAgain];
}

class NetworkErrorEvent extends Error {}
