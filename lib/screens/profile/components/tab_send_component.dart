import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/wallets/wallet_transfer_model.dart';
import 'package:ootopia_app/data/repositories/wallet_repository.dart';
import 'package:ootopia_app/screens/profile/components/card_information_balance.dart';

class TabSendComponent extends StatefulWidget {
  final WalletRepositoryImpl walletRepositoryImpl;
  const TabSendComponent({required this.walletRepositoryImpl});
  @override
  _TabSendComponentState createState() => _TabSendComponentState();
}

class _TabSendComponentState extends State<TabSendComponent> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WalletTransfer>>(
        future: widget.walletRepositoryImpl.getTransactionHistory(
            50, 0, '19dce8cb-358b-4765-93e4-d1d581b75675', 'sent'),
        builder: (context, snapshot) {
          print(snapshot.hasError);
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Text('Texto'),
            );
          }
          return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return CardInformationBalance('valueTransaction', 'imageAvatar',
                    'imageRectangulo', 'toOrFrom', 'typeTransaction');
              });
        });
  }
}
