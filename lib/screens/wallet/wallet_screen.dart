import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/home/components/page_view_controller.dart';
import 'package:ootopia_app/screens/wallet/components/tab_history.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:flutter/gestures.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late WalletStore walletStore;
  late HomeStore homeStore;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      walletStore.getWallet();
    });

    PageViewController.instance.addListener(() {
      if (PageViewController.instance.controller.page == 1) {
        _performAllRequests();
      }
    });
  }

  Future<void> _performAllRequests() async {
    await walletStore.getWallet();
    await walletStore.getWalletTransfersHistory(0); //all
    await walletStore.getWalletTransfersHistory(0, "received"); //received
    await walletStore.getWalletTransfersHistory(0, "sent"); //sent
  }

  @override
  Widget build(BuildContext context) {
    homeStore = Provider.of<HomeStore>(context);
    walletStore = Provider.of<WalletStore>(context);
    return DefaultTabController(
      length: 3,
      child: Observer(
        builder: (_) {
          return Scaffold(
            body: Container(
              padding: EdgeInsets.only(top: 16),
              child: RefreshIndicator(
                onRefresh: () async {
                  await _performAllRequests();
                },
                child: ListView(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 0),
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
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                height: 30,
                                width: MediaQuery.of(context).size.width * 0.3,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  border: Border.all(color: Color(0xff003694)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/ooz-coin-blue-small.svg',
                                      color: Color(0xff003694),
                                    ),
                                    Container(
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
                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(top: 8),
                            child: Text(
                              AppLocalizations.of(context)!.textExplainWallet,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 0),
                            child: RichText(
                              text: TextSpan(
                                text: AppLocalizations.of(context)!.learnMore,
                                style: TextStyle(
                                  color: Color(0xff003694),
                                  fontSize: 14,
                                ),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () => setState(
                                        () {
                                          showModalBottomSheet(
                                            context: context,
                                            barrierColor:
                                                Colors.black.withAlpha(1),
                                            backgroundColor:
                                                Colors.black.withAlpha(1),
                                            builder: (BuildContext context) {
                                              return SnackBarWidget(
                                                menu: AppLocalizations.of(
                                                        context)!
                                                    .regenerationGame,
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .aboutRegenerationGame,
                                                about: AppLocalizations.of(
                                                        context)!
                                                    .learnMore,
                                                marginBottom: true,
                                              );
                                            },
                                          );
                                        },
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 52,
                      child: Container(
                        padding: EdgeInsetsDirectional.all(0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Color.fromRGBO(112, 112, 112, 0.2),
                          ),
                        ),
                        child: TabBar(
                          unselectedLabelColor: Color(0xff707070),
                          labelColor: Color(0xff003694),
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
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
                      height: MediaQuery.of(context).size.height * 0.61,
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
