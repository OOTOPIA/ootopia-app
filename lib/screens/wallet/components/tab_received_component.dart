import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/data/models/wallets/wallet_transfer_model.dart';
import 'package:ootopia_app/data/repositories/wallet_repository.dart';
import 'package:ootopia_app/screens/wallet/components/card_information_balance.dart';
import 'package:ootopia_app/screens/wallet/components/chip_information_date_and_sum.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              child: Text(AppLocalizations.of(context)!.youDontReceived),
            );
          }

          return ListView(
            children: snapshot.data!.entries.map((e) {
              String sumFormated =
                  widget.mapSumDaysTransfer[e.key].toString().length > 7
                      ? NumberFormat.compact()
                          .format(widget.mapSumDaysTransfer[e.key])
                          .replaceAll('.', ',')
                      : widget.mapSumDaysTransfer[e.key]
                          .toString()
                          .replaceAll('.', ',');

              int lengthItemMapSumOfDayTransfer = sumFormated.length;
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
                            '${e.balance}',
                            '${e.photoUrl ?? ''}',
                            'https://via.placeholder.com/150/FF0000/FFFFFF?Text=Down.com',
                            '${e.otherUsername ?? ''}',
                            'Personal Goal Achieved',
                            0xff018F9C,
                            'Received');
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
