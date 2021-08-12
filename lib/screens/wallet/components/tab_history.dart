import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/data/models/wallets/wallet_transfer_model.dart';
import 'package:ootopia_app/screens/wallet/components/card_information_balance.dart';
import 'package:ootopia_app/screens/wallet/components/chip_information_date_and_sum.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';

class TabHistory extends StatefulWidget {
  final String action;
  final WalletStore store;
  const TabHistory(
    this.store,
    this.action,
  );

  @override
  TabHistoryState createState() => TabHistoryState();
}

class TabHistoryState extends State<TabHistory> {
  Map<String, List<WalletTransfer>>? groupedTransfersByDate;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _performRequest();
    });
  }

  Future<void> _performRequest() async {
    switch (widget.action) {
      case "all":
        await widget.store.getWalletTransfersHistory(0);
        groupedTransfersByDate = widget.store.allGroupedTransfersByDate;
        break;
      case "received":
        await widget.store.getWalletTransfersHistory(0, "received");
        groupedTransfersByDate = widget.store.receivedGroupedTransfersByDate;
        break;
      case "sent":
        await widget.store.getWalletTransfersHistory(0, "sent");
        groupedTransfersByDate = widget.store.sentGroupedTransfersByDate;
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => RefreshIndicator(
        onRefresh: () => _performRequest(),
        child: ListView(
          children: groupedTransfersByDate == null
              ? [
                  Padding(
                    padding: EdgeInsets.all(60),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ]
              : groupedTransfersByDate!.entries.map((e) {
                  String sumFormated = '';
                  int lengthItemMapSumOfDayTransfer = 0;
                  sumFormated =
                      widget.store.mapSumDaysTransfer[e.key].toString().length >
                              7
                          ? NumberFormat.compact()
                              .format(widget.store.mapSumDaysTransfer[e.key])
                          : widget.store.mapSumDaysTransfer[e.key].toString();
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
                                balanceOfTransactions:
                                    '${e.balance.toStringAsFixed(2)}',
                                iconForeground: '${e.photoUrl ?? ''}',
                                iconBackground: '${e.icon}',
                                toOrFrom: '${e.otherUsername ?? ''}',
                                originTransaction: '${e.origin}',
                                action: '${e.action}',
                                otherUserId: '${e.otherUserId}');
                          }).toList(),
                        )
                      ],
                    ),
                  );
                }).toList(),
        ),
      ),
    );
  }
}
