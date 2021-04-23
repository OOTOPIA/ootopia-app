import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ootopia_app/data/models/wallets/wallet_model.dart';
import 'package:ootopia_app/data/repositories/wallet_repository.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletRepository repository;

  WalletBloc(this.repository) : super(LoadingWalletState());

  @override
  WalletState get initialState => LoadingWalletState();

  @override
  Stream<WalletState> mapEventToState(
    WalletEvent event,
  ) async* {
    // Emitting a state from the asynchronous generator
    // Branching the executed logic by checking the event type
    LoadingWalletState();
    if (event is GetWalletEvent) {
      yield LoadingWalletState();
      yield* _mapGetWalletToState(event);
    }
  }

  Stream<WalletState> _mapGetWalletToState(GetWalletEvent event) async* {
    try {
      Wallet wallet = (await this.repository.getWallet(event.userId));
      print("Tudo certo ${wallet.toString()}");
      yield LoadedWalletSucessState(wallet: wallet);
    } catch (_) {
      print("ERRO MANO NO WALLET");
      yield LoadWalletErrorState("Error loading wallet");
    }
  }
}
