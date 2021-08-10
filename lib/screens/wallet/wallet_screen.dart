import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/data/models/wallets/wallet_model.dart';
import 'package:ootopia_app/screens/wallet/components/tab_all_component.dart';
import 'package:ootopia_app/screens/wallet/components/tab_received_component.dart';
import 'package:ootopia_app/screens/wallet/components/tab_send_component.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  WalletStore walletStore = WalletStore();
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
                          avatar: SvgPicture.asset(
                            'assets/icons/ooz-coin-blue-small.svg',
                            color: Color(0xff003694),
                          ),
                          label: Container(
                            width: 55,
                            child: FutureBuilder<Wallet>(
                                future: walletStore.getBalanceUser(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return CircularProgressIndicator();
                                  }
                                  return Text(
                                    '${snapshot.data!.totalBalance.toString().length > 6 ? NumberFormat.compact().format(snapshot.data?.totalBalance).replaceAll('.', ',') : snapshot.data?.totalBalance.toStringAsFixed(2).replaceAll('.', ',')}',
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
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Color(0xff018F9C),
                            builder: (BuildContext context) {
                              return SnackBarWidget(
                                menu: AppLocalizations.of(context)!.regenerationGame,
                                text: AppLocalizations.of(context)!.aboutRegenerationGame,
                                about: AppLocalizations.of(context)!.learnMore,
                              );
                            },
                          );
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
                    Observer(builder: (context) {
                      return TabAllComponent(
                        walletRepositoryImpl: walletStore.walletRepositoryImpl,
                        getUserTransactionHistory:
                            walletStore.getUserTransactionHistory,
                        mapSumDaysTransfer: walletStore.mapSumDaysTransfer,
                      );
                    }),
                    Observer(builder: (context) {
                      return TabReceivedComponent(
                        walletRepositoryImpl: walletStore.walletRepositoryImpl,
                        getUserTransactionHistory:
                            walletStore.getUserTransactionHistory('received'),
                        mapSumDaysTransfer: walletStore.mapSumDaysTransfer,
                      );
                    }),
                    Observer(builder: (context) {
                      return TabSendComponent(
                        walletRepositoryImpl: walletStore.walletRepositoryImpl,
                        getUserTransactionHistory:
                            walletStore.getUserTransactionHistory('sent'),
                        mapSumDaysTransfer: walletStore.mapSumDaysTransfer,
                      );
                    }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
