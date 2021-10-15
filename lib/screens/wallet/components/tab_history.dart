import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/data/models/wallets/wallet_transfer_model.dart';
import 'package:ootopia_app/screens/wallet/components/card_information_balance.dart';
import 'package:ootopia_app/screens/wallet/components/chip_information_date_and_sum.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    switch (widget.action) {
      case "all":
        groupedTransfersByDate = widget.store.allGroupedTransfersByDate;
        break;
      case "received":
        groupedTransfersByDate = widget.store.receivedGroupedTransfersByDate;
        break;
      case "sent":
        groupedTransfersByDate = widget.store.sentGroupedTransfersByDate;
        break;
    }

    return Observer(
      builder: (_) => RefreshIndicator(
        onRefresh: () => _performRequest(),
        child: ListView(
          children: groupedTransfersByDate == null
              ? [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.62,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ]
              : groupedTransfersByDate!.isEmpty
                  ? [
                      Opacity(
                        opacity: 0.5,
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.62,
                            color: Colors.white,
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/icons/ooz-coin-medium.png',
                                    width: 28,
                                    height: 28,
                                    color: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .color),
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text(
                                      AppLocalizations.of(context)!
                                          .thereAreNoWalletRecords,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                            fontSize: 16,
                                          )),
                                ),
                              ],
                            ))),
                      )
                    ]
                  : groupedTransfersByDate!.entries.map((e) {
                      final f = new NumberFormat("0.00");
                      String sumFormated = '';
                      int lengthItemMapSumOfDayTransfer = 0;
                      sumFormated =
                          f.format(widget.store.mapSumDaysTransfer[e.key]);
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 16,
                          bottom: 0,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 16,
                              ),
                              child: ChipSumForDate(
                                date: e.key,
                                lengthItemMapSumOfDayTransfer:
                                    lengthItemMapSumOfDayTransfer,
                                sumFormated: sumFormated,
                              ),
                            ),
                            Column(
                              children: e.value.map((_e) {
                                return Container(
                                  padding: EdgeInsets.only(
                                    bottom: 19,
                                  ),
                                  child: CardInformationBalance(
                                    balanceOfTransactions:
                                        '${_e.balance.toStringAsFixed(2)}',
                                    iconForeground: _e.photoUrl ?? "",
                                    iconBackground: _e.icon ?? '',
                                    toOrFrom: _e.otherUsername ?? '',
                                    originTransaction: '${_e.origin}',
                                    action: '${_e.action}',
                                    otherUserId: '${_e.otherUserId}',
                                    postId: _e.postId,
                                    description: _e.description,
                                    origin: _e.origin,
                                    learningTrackId: _e.learningTrackId ?? '',
                                    updateCardInformationBalance:
                                        _performRequest,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
        ),
      ),
    );
  }
}
