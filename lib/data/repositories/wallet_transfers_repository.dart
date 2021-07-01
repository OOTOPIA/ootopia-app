import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ootopia_app/data/models/wallets/wallet_model.dart';
import 'package:ootopia_app/data/utils/fetch-data-exception.dart';
import 'dart:convert';

import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class WalletTransfersRepository {
  Future<void> transferOOZToPost(String postId, double balance,
      [bool? dontAskToConfirmAgain]);
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class WalletTransfersRepositoryImpl
    with SecureStoreMixin
    implements WalletTransfersRepository {
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

  Future<void> transferOOZToPost(String postId, double balance,
      [bool? dontAskToConfirmAgain]) async {
    final response = await http.post(
      Uri.parse(
          dotenv.env['API_URL']! + 'wallet-transfers/post/$postId/transfer'),
      headers: await this.getHeaders(),
      body: jsonEncode(
        <String, String>{
          'balance': balance.toString(),
          'dontAskAgainToConfirmGratitudeReward':
              dontAskToConfirmAgain.toString(),
        },
      ),
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      Map<String, dynamic> decode = json.decode(response.body);
      if (decode['error'] == "INSUFFICIENT_BALANCE") {
        throw FetchDataException(decode['error']);
      } else {
        throw FetchDataException('Failed to transfer OOZ');
      }
    } else {
      throw FetchDataException('Error while transferring.');
    }
  }
}
