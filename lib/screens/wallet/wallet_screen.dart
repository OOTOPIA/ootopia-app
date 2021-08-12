import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/screens/wallet/components/tab_history.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late WalletStore walletStore;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      walletStore.getWallet();
    });
  }

  Future<void> _performAllRequests() async {
    walletStore.getWallet();
    walletStore.getWalletTransfersHistory(0); //all
    walletStore.getWalletTransfersHistory(0, "received"); //received
    walletStore.getWalletTransfersHistory(0, "sent"); //sent
  }

  @override
  Widget build(BuildContext context) {
    walletStore = Provider.of<WalletStore>(context);
    return DefaultTabController(
      length: 3,
      child: Observer(
        builder: (_) {
          return Scaffold(
            body: Container(
              padding: EdgeInsets.only(top: 3),
              child: RefreshIndicator(
                onRefresh: () async {
                  await _performAllRequests();
                },
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
                                  child: Text(
                                    walletStore.wallet != null
                                        ? '${walletStore.wallet!.totalBalance.toString().length > 6 ? NumberFormat.compact().format(walletStore.wallet?.totalBalance).replaceAll('.', ',') : walletStore.wallet?.totalBalance.toStringAsFixed(2).replaceAll('.', ',')}'
                                        : '0,00',
                                    style: TextStyle(
                                      color: Color(0xff003694),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
                                barrierColor: Colors.black.withAlpha(1),
                                backgroundColor: Colors.black.withAlpha(1),
                                builder: (BuildContext context) {
                                  return SnackBarWidget(
                                    menu: AppLocalizations.of(context)!
                                        .regenerationGame,
                                    text: AppLocalizations.of(context)!
                                        .aboutRegenerationGame,
                                    about:
                                        AppLocalizations.of(context)!.learnMore,
                                    marginBottom: true,
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
                            ),
                          ),
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
                          TabHistory(walletStore, "all"),
                          TabHistory(walletStore, "received"),
                          TabHistory(walletStore, "sent"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
