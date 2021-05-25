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

class LoadingTransactionHistoryState extends WalletState {
  const LoadingTransactionHistoryState();
  @override
  List<Object> get props => [];
}

class LoadedTransactionHistorySucessState extends WalletState {
  List<WalletTransfer> transactions;
  LoadedTransactionHistorySucessState({this.transactions});
  @override
  List<Object> get props => [transactions];
}

class LoadTransactionHistoryErrorState extends WalletState {
  final String message;
  const LoadTransactionHistoryErrorState(this.message);
  @override
  List<Object> get props => [message];
}
