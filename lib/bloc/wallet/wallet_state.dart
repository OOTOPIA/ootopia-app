part of 'wallet_bloc.dart';

abstract class WalletState extends Equatable {
  const WalletState();
}

class EmptyState extends WalletState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadingWalletState extends WalletState {
  const LoadingWalletState();
  @override
  List<Object> get props => [];
}

class LoadedWalletSucessState extends WalletState {
  Wallet wallet;
  LoadedWalletSucessState({this.wallet});
  @override
  List<Object> get props => [wallet];
}

class LoadWalletErrorState extends WalletState {
  final String message;
  const LoadWalletErrorState(this.message);
  @override
  List<Object> get props => [message];
}
