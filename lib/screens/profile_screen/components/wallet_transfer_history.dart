import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/wallets/wallet_transfer_group_model.dart';
import 'package:ootopia_app/data/models/wallets/wallet_transfer_model.dart';

class WalletTransferHistory extends StatelessWidget {
  List<WalletTransferGroup> walletTransferGroup;

  WalletTransferHistory({this.walletTransferGroup});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: this.walletTransferGroup.length,
      itemBuilder: (context, index) {
        var group = this.walletTransferGroup[index];
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "OOZ received on ${group.date}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            TransactionItemWidget(group.transfers),
          ],
        );
      },
    );
  }
}

class TransactionItemWidget extends StatelessWidget {
  final List<WalletTransfer> walletTransfers;
  const TransactionItemWidget(
    this.walletTransfers, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: this.walletTransfers.length,
      itemBuilder: (context, index) {
        var walletTransfer = this.walletTransfers[index];
        return Container(
          height: 45,
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.only(left: 3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.fromBorderSide(
              BorderSide(
                color: Color(0xffBDBDBD),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 39,
                    width: 39,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                      border: Border.fromBorderSide(
                        BorderSide(
                          color: Color(0xffBDBDBD),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      "from ${walletTransfer.otherUsername}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("OOZ " + walletTransfer.balance.toString()),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
