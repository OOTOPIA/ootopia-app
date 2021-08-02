import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/data/models/wallets/wallet_transfer_model.dart';
import 'package:ootopia_app/screens/profile/components/card_information_balance.dart';
import 'package:ootopia_app/data/repositories/wallet_repository.dart';

class TabAllComponent extends StatefulWidget {
  final WalletRepositoryImpl walletRepositoryImpl;
  const TabAllComponent({required this.walletRepositoryImpl});

  @override
  _TabAllComponentState createState() => _TabAllComponentState();
}

class _TabAllComponentState extends State<TabAllComponent> {
  double soma = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WalletTransfer>>(
        future: widget.walletRepositoryImpl.getTransactionHistory(
            50, 0, '19dce8cb-358b-4765-93e4-d1d581b75675'),
        builder: (context, snapshot) {
          print(snapshot.hasError);
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
          return ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                if (snapshot.data![index + 1].createdAt ==
                    snapshot.data![index].createdAt) {
                  soma = snapshot.data![index].balance + soma;
                }

                return Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Column(
                    children: [
                      snapshot.data![index].createdAt ==
                              snapshot.data![index + 1].createdAt
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${DateFormat('MMMM d, y').format(DateTime.parse(snapshot.data![index].createdAt))}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xff003694),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                        'assets/icons/ooz-coin-small.png'),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '$soma',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                      CardInformationBalance(
                          '${snapshot.data![index].balance}',
                          'https://via.placeholder.com/140x100',
                          'https://via.placeholder.com/150/FF0000/FFFFFF?Text=Down.com',
                          '${snapshot.data![index].otherUsername ?? ''}',
                          'Personal Goal Achieved'),
                    ],
                  ),
                );
              });
        });
  }
}
