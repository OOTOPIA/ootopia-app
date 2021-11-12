import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ootopia_app/data/repositories/wallet_transfers_repository.dart';
import 'package:ootopia_app/data/utils/fetch-data-exception.dart';

part 'wallet_transfer_event.dart';
part 'wallet_transfer_state.dart';

class WalletTransferBloc
    extends Bloc<WalletTransferEvent, WalletTransferState> {
  WalletTransfersRepository repository;

  WalletTransferBloc(this.repository) : super(EmptyState());

  WalletTransferState get initialState => EmptyState();

  @override
  Stream<WalletTransferState> mapEventToState(
    WalletTransferEvent event,
  ) async* {
    // Emitting a state from the asynchronous generator
    // Branching the executed logic by checking the event type
    LoadingGratitudeRewardState();
    if (event is SendGratitudeRewardEvent) {
      yield LoadingGratitudeRewardState();
      yield* _mapSendGratitudeReward(event);
    }
  }

  Stream<WalletTransferState> _mapSendGratitudeReward(
      SendGratitudeRewardEvent event) async* {
    try {
      await this.repository.transferOOZToPost(
          event.postId, event.balance, event.dontAskToConfirmAgain);
      yield GratitudeRewardSuccessState();
    } on FetchDataException catch (e) {
      print("ERRO AO ENVIAR OOZ ${e.toString()}");
      yield GratitudeRewardErrorState(e.toString());
    }
  }
}
