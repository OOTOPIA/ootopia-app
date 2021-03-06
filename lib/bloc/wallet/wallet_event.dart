part of 'wallet_bloc.dart';

//@immutable
abstract class WalletEvent extends Equatable {
  const WalletEvent();
}

class LoadingWalletEvent extends WalletEvent {
  @override
  List<Object> get props => [];
}

class GetWalletEvent extends WalletEvent {
  final String userId;
  const GetWalletEvent(this.userId);
  @override
  List<Object> get props => [userId];
}

class GetTransactionHistoryEvent extends WalletEvent {
  final int limit;
  final int offset;
  final String userId;
  final String action;
  const GetTransactionHistoryEvent(
      this.limit, this.offset, this.userId, this.action);
  @override
  List<Object> get props => [this.limit, this.offset, this.userId, this.action];
}

class NetworkErrorEvent extends Error {}
