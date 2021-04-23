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

class NetworkErrorEvent extends Error {}
