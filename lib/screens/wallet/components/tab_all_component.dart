import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/data/models/wallets/wallet_transfer_model.dart';
import 'package:ootopia_app/screens/wallet/components/card_information_balance.dart';
import 'package:ootopia_app/data/repositories/wallet_repository.dart';
import 'package:ootopia_app/screens/wallet/components/chip_information_date_and_sum.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/screens/wallet/helper/origin_ooz.dart';

class TabAllComponent extends StatefulWidget {
  final WalletRepositoryImpl walletRepositoryImpl;
  final getUserTransactionHistory;
  final mapSumDaysTransfer;
  const TabAllComponent(
      {required this.walletRepositoryImpl,
      required this.getUserTransactionHistory,
      required this.mapSumDaysTransfer});

  @override
  _TabAllComponentState createState() => _TabAllComponentState();
}

class _TabAllComponentState extends State<TabAllComponent> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<WalletTransfer>>>(
        future: widget.getUserTransactionHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (!snapshot.hasData) {
            return  Center(
              child:CircularProgressIndicator() 
            );
          }
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.youDontNothing),
            );
          }

          return ListView(
            children: snapshot.data!.entries.map((e) {
              String sumFormated = '';
              int lengthItemMapSumOfDayTransfer = 0;
              sumFormated =
                  widget.mapSumDaysTransfer[e.key].toString().length > 7
                      ? NumberFormat.compact()
                          .format(widget.mapSumDaysTransfer[e.key])
                      : widget.mapSumDaysTransfer[e.key].toString();

              lengthItemMapSumOfDayTransfer = sumFormated.length;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ChipSumForDate(
                      date: e.key,
                      lengthItemMapSumOfDayTransfer:
                          lengthItemMapSumOfDayTransfer,
                      sumFormated: sumFormated,
                    ),
                    Column(
                      children: e.value.map((e) {
                        return CardInformationBalance(
                            balanceOfTransactions: '${e.balance.toStringAsFixed(2)}',
                            iconForeground: '${e.photoUrl ?? ''}',
                            iconBackground: '${e.icon }',
                            toOrFrom: '${e.otherUsername ?? ''}',
                            originTransaction: '${e.origin}',
                            action: '${e.action}');
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
