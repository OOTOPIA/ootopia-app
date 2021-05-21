part of 'wallet_transfer_bloc.dart';

abstract class WalletTransferState extends Equatable {
  const WalletTransferState();
}

class EmptyState extends WalletTransferState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadingGratitudeRewardState extends WalletTransferState {
  const LoadingGratitudeRewardState();
  @override
  List<Object> get props => [];
}

class GratitudeRewardSuccessState extends WalletTransferState {
  GratitudeRewardSuccessState();
  @override
  List<Object> get props => [];
}

class GratitudeRewardErrorState extends WalletTransferState {
  final String message;
  const GratitudeRewardErrorState(this.message);
  @override
  List<Object> get props => [message];
}
