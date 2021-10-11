import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/repositories/marketplace_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/screens/marketplace/components/get_adaptive_size.dart';

part 'transfer_store.g.dart';

class TransferStore = _TransferStoreBase with _$TransferStore;

abstract class _TransferStoreBase with Store {
  MarketplaceRepositoryImpl marketplaceRepositoryImpl =
      MarketplaceRepositoryImpl();

  @observable
  bool isLoading = false;

  @action
  Future<bool> makePurchase(
      {required String productId, required String optionalMessage}) async {
    try {
      isLoading = true;
      final response = await marketplaceRepositoryImpl.makePurchase(
          productId: productId, optionalMessage: optionalMessage);
      isLoading = false;
      return response.statusCode == 201;
    } catch (e) {
      isLoading = false;
      if (e is DioError) throw Exception(e.response?.data["error"]);

      throw Exception(e);
    }
  }

  showSnackbarMessage(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message.contains(
            "INSUFFICIENT_BALANCE",
          )
              ? AppLocalizations.of(context)!.insufficientBalance
              : AppLocalizations.of(context)!.generalError,
          style: TextStyle(fontSize: getAdaptiveSize(14, context)),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
