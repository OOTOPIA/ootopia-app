import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/data/models/wallets/wallet_transfer_model.dart';
import 'package:ootopia_app/data/repositories/wallet_repository.dart';
import 'package:ootopia_app/screens/wallet/components/card_information_balance.dart';

class TabReceivedComponent extends StatefulWidget {
  final WalletRepositoryImpl walletRepositoryImpl;
  final getUserTransactionHistory;
  final mapSumDaysTransfer;
  const TabReceivedComponent(
      {required this.walletRepositoryImpl,
      this.getUserTransactionHistory,
      this.mapSumDaysTransfer});

  @override
  TabReceivedComponentState createState() => TabReceivedComponentState();
}

class TabReceivedComponentState extends State<TabReceivedComponent> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<WalletTransfer>>>(
        future: widget.getUserTransactionHistory,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Text('Texto'),
            );
          }

          return ListView(
            children: snapshot.data!.entries.map((e) {
              var numberToFormat = 125.5;
              var _formattedNumber =
                  NumberFormat.compact().format(numberToFormat);
              print('Formatted Number is $_formattedNumber');
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${e.key}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff003694),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Wrap(
                          spacing: 30,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Image.asset('assets/icons/ooz-coin-small.png'),
                            Text(
                              '${widget.mapSumDaysTransfer.containsKey(e.key) ? widget.mapSumDaysTransfer[e.key] : ''}',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: e.value.map((e) {
                        return CardInformationBalance(
                            '${e.balance}',
                            'https://via.placeholder.com/140x100',
                            'https://via.placeholder.com/150/FF0000/FFFFFF?Text=Down.com',
                            '${e.otherUsername ?? ''}',
                            'Personal Goal Achieved');
                      }).toList(),
                    )
                  ],
                ),
              );
            }).toList(),
          );
        });
  }
}
