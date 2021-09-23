import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/models/wallets/wallet_transfer_model.dart';
import 'package:ootopia_app/data/models/wallets/wallet_model.dart';
import 'package:ootopia_app/data/repositories/api.dart';
import 'dart:convert';

import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class WalletRepository {
  Future<Wallet> getWallet(String userId);
  Future<List<WalletTransfer>> getTransactionHistory(
      [int limit, int offset, String action]);
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class WalletRepositoryImpl with SecureStoreMixin implements WalletRepository {
  Future<Map<String, String>> getHeaders() async {
    bool loggedIn = await getUserIsLoggedIn();
    if (!loggedIn) {
      return API_HEADERS;
    }

    String? token = await getAuthToken();
    if (token == null) return API_HEADERS;

    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + token
    };
  }

  Future<Wallet> getWallet(String userId) async {
    try {
      final response = await http.get(
        Uri.parse(dotenv.env['API_URL']! + "wallets/$userId"),
        headers: await this.getHeaders(),
      );
      if (response.statusCode == 200) {
        print("WALLET RESPONSE ${response.body}");
        return Future.value(Wallet.fromJson(json.decode(response.body)));
      } else {
        throw Future.error('Failed to load wallet');
      }
    } catch (error) {
      return Future.error('Failed to load wallet. Error: $error');
    }
  }

  Future<List<WalletTransfer>> getTransactionHistory(
      [int? limit, int? offset, String? action]) async {
    try {
      Map<String, String> queryParams = {};

      if (limit != null && offset != null) {
        queryParams['limit'] = limit.toString();
        queryParams['offset'] = offset.toString();
      }

      if (action != null) {
        queryParams['action'] = action.toString();
      }

      User user = (await getCurrentUser())!;
      String queryString = Uri(queryParameters: queryParams).query;

      Response response = await ApiClient.api().get(
        "wallet-transfers/${user.id}/history?$queryString",
      );

      if (response.statusCode == 200) {
        print("WALLET RESPONSE HISTORY --> ${response.data}");

        return (response.data as List)
            .map((i) => WalletTransfer.fromJson(i))
            .toList();
      } else {
        throw Exception('Failed to load wallet');
      }
    } catch (error) {
      throw Exception('Failed to load wallet: ' + error.toString());
    }
  }
}
