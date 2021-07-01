import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/wallets/wallet_transfer_group_model.dart';
import 'package:ootopia_app/data/models/wallets/wallet_transfer_model.dart';

class WalletTransferHistory extends StatelessWidget {
  List<WalletTransferGroup> walletTransferGroup;

  WalletTransferHistory({required this.walletTransferGroup});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: this.walletTransferGroup.length,
        itemBuilder: (context, index) {
          var group = this.walletTransferGroup[index];
          return Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      "${group.date[00]}${group.date[01]}.${group.date[03]}${group.date[04]}.${group.date[06]}${group.date[07]}${group.date[08]}${group.date[09]}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  )),
              TransactionItemWidget(group.transfers),
            ],
          );
        },
      ),
    );
  }
}

class TransactionItemWidget extends StatelessWidget {
  final List<WalletTransfer> walletTransfers;
  const TransactionItemWidget(
    this.walletTransfers, {
    Key? key,
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
                color: Color(0xFF909090),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  walletTransfer.photoUrl != null
                      ? CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                NetworkImage("${walletTransfer.photoUrl}"),
                            radius: 19,
                          ),
                        )
                      : CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                                walletTransfer.fromPlatform
                                    ? "assets/icons/icon_launcher.png"
                                    : "assets/icons_profile/profile.png"),
                            radius: 19,
                          ),
                        ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          walletTransfer.origin == "video_like"
                              ? "Gratitude reward"
                              : "Transfer",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: walletTransfer.origin == "video_like"
                                  ? Color(0XFF0AA7EA)
                                  : Color(0XFF06804D)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          walletTransfer.action == "sent"
                              ? "to" +
                                  " ${(walletTransfer.otherUsername != null ? walletTransfer.otherUsername : "<vazio>")}"
                              : "from" +
                                  " ${(walletTransfer.fromPlatform ? "OOTOPIA" : (walletTransfer.otherUsername != null ? walletTransfer.otherUsername : "<vazio>"))}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    text: TextSpan(
                      text: "OOz ",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                          text: walletTransfer.balance != null
                              ? walletTransfer.balance.toString()
                              : "0,00",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
