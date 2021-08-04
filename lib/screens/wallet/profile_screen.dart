import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/data/models/wallets/wallet_model.dart';
import 'package:ootopia_app/data/models/wallets/wallet_transfer_model.dart';
import 'package:ootopia_app/data/repositories/wallet_repository.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/wallet/components/tab_all_component.dart';
import 'package:ootopia_app/screens/wallet/components/tab_received_component.dart';
import 'package:ootopia_app/screens/wallet/components/tab_send_component.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  WalletRepositoryImpl walletRepositoryImpl = WalletRepositoryImpl();
  Map<String, double> mapSumDaysTransfer = {};
  Future<Map<String, List<WalletTransfer>>> getUserTransactionHistory(
      [String? typeTransaction]) async {
    var resultTransactions = await walletRepositoryImpl.getTransactionHistory(
        50, 0, '19dce8cb-358b-4765-93e4-d1d581b75675', typeTransaction);
    var map = groupBy(
        resultTransactions,
        (WalletTransfer obj) => DateFormat('MMM d, y')
            .format(DateTime.parse(obj.createdAt))
            .toString());
    map.entries.forEach((element) {
      var soma = 0.0;
      element.value.forEach((element) {
        soma = element.balance + soma;
      });
      mapSumDaysTransfer.addAll({element.key: soma});
    });

    return map;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: 3),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(23.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'OOz ${AppLocalizations.of(context)!.totalBalance}',
                          style: TextStyle(
                            color: Color(0xff003694),
                            fontSize: 20,
                          ),
                        ),
                        Chip(
                          shape: StadiumBorder(
                              side: BorderSide(color: Color(0xff003694))),
                          backgroundColor: Colors.white,
                          avatar:
                              Image.asset('assets/icons/ooz-coin-small.png'),
                          label: Container(
                            width: 65,
                            child: FutureBuilder<Wallet>(
                                future: walletRepositoryImpl.getWallet(
                                    '19dce8cb-358b-4765-93e4-d1d581b75675'),
                                builder: (context, snapshot) {
                                  return Text(
                                    '${snapshot.data!.totalBalance.toString().length > 6 ? NumberFormat.compact().format(snapshot.data?.totalBalance) : snapshot.data?.totalBalance.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Color(0xff003694),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }),
                          ),
                        )
                      ],
                    ),
                    Text(
                      AppLocalizations.of(context)!.textExplainWallet,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          _configurandoModalBottomSheet(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.learnMore,
                          style: TextStyle(
                            color: Color(0xff003694),
                            fontSize: 14,
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: AppBar(
                  backgroundColor: Colors.white,
                  bottom: TabBar(
                    unselectedLabelColor: Colors.grey,
                    labelColor: Color(0xff003694),
                    tabs: [
                      Tab(
                        text: AppLocalizations.of(context)!.all,
                      ),
                      Tab(
                        text: AppLocalizations.of(context)!.received,
                      ),
                      Tab(
                        text: AppLocalizations.of(context)!.sent,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.56,
                child: TabBarView(
                  children: [
                    TabAllComponent(
                      walletRepositoryImpl: walletRepositoryImpl,
                      getUserTransactionHistory: getUserTransactionHistory,
                      mapSumDaysTransfer: mapSumDaysTransfer,
                    ),
                    TabReceivedComponent(
                      walletRepositoryImpl: walletRepositoryImpl,
                      getUserTransactionHistory:
                          getUserTransactionHistory('received'),
                      mapSumDaysTransfer: mapSumDaysTransfer,
                    ),
                    TabSendComponent(
                      walletRepositoryImpl: walletRepositoryImpl,
                      getUserTransactionHistory:
                          getUserTransactionHistory('sent'),
                      mapSumDaysTransfer: mapSumDaysTransfer,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _configurandoModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Color(0xff018F9C),
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.all(26),
            child: Wrap(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Regeneration Game',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    Icon(Icons.close)
                  ],
                ),
                Text(
                  'The Regeneration Game is a way you can contribute to regenerative movement through the OOTOPIA app. The Personal Goal refers to the time you commit to playing the game per day. When you meet your daily goal, you receive a credit reward in OOz. Every day at 20:00, a new round begins, lasting 24 hours.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    AppLocalizations.of(context)!.learnMore,
                    style: TextStyle(color: Color(0xff03DAC5)),
                  ),
                )
              ],
            ),
          );
        });
  }
}
