import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/data/models/wallets/wallet_transfer_model.dart';
import 'package:ootopia_app/screens/wallet/components/item_history.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';

class TabHistory extends StatefulWidget {
  final String action;
  final double pageSize;
  final WalletStore store;

  const TabHistory(this.store, this.action, this.pageSize);

  @override
  TabHistoryState createState() => TabHistoryState();
}

class TabHistoryState extends State<TabHistory> {
  Map<String, List<WalletTransfer>>? groupedTransfersByDate;
  final format = new NumberFormat("0.00");
  List days = [];
  List itemsDay = [];
  final ScrollController _scrollController = ScrollController();
  bool hasMoreItems = true;
  int page = 1;
  bool isLoadingMore = false;


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() async {
      if(canLoadMore()){
        await getMore();
      }
    });
    Future.delayed(Duration.zero, () async {
      await _performRequest();
      init();
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
    return RefreshIndicator(
      onRefresh: () => _performRequest(),
      child: Column(
        children: [
          if(groupedTransfersByDate == null)...[
            Container(
              height: widget.pageSize,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ]else if(groupedTransfersByDate!.isEmpty)...[
            Opacity(
              opacity: 0.5,
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.62,
                  //color: Colors.white,
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
            ),
          ]else...[
            Container(
              height: widget.pageSize,
              child: ListView.builder(
                  controller: _scrollController,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  itemCount: days.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ItemHistory(
                      dayTitle: days[index],
                      daysItem: itemsDay[index],
                      sumFormatted: format.format(widget.store.mapSumDaysTransfer[days[index]]),
                      performRequest: ()=> _performRequest(),
                    );
                  }
              ),
            ),
          ]
        ],
      ),
    );
  }

  void init() {
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


    if(groupedTransfersByDate != null){
      days = [];
      itemsDay = [];
      days.addAll((groupedTransfersByDate!.keys));
      itemsDay.addAll(groupedTransfersByDate!.values);
    }
  }

  bool canLoadMore() {
    return _scrollController.offset >= _scrollController.position.maxScrollExtent*0.8 &&
        hasMoreItems && !isLoadingMore;
  }

  void changeLoadMore(bool value) {
    setState(() {
      isLoadingMore = value;
    });
  }

  Future<void> getMore() async {
    print('get more init');
    changeLoadMore(true);
    final Map<String, List<WalletTransfer>>? aux = await widget.store.getWalletTransfersHistory(page++, getKindOfPage());
    aux!.forEach((key, value) {
      bool sameDay = false;
      for(int i = 0; i < days.length; i++){
        if(days[i] == key ){
          sameDay = true;
          List items = value;
          for(int f = 0; f < items.length; f++) {
            itemsDay[i].add(items[f]);
          }
        }
      }
      if(!sameDay){
        days.add(key);
        itemsDay.add(value);
      }
    });
    setState(() {});
    print('get more end');
    Future.delayed(Duration(seconds: 1), (){
    changeLoadMore(false);
    });
  }

  String? getKindOfPage() {
    if(widget.action == 'all'){
      return null;
    }else{
      return widget.action;
    }


  }
}




