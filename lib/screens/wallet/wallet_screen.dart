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
import 'package:smart_page_navigation/smart_page_navigation.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with TickerProviderStateMixin {
  late HomeStore homeStore;

  late WalletStore walletStore;
  late TabController _tabController;
  int _activeTabIndex = 0;
  SmartPageController controller = SmartPageController.getInstance();

  @override
  void initState() {
    super.initState();

    _tabController = new TabController(length: 3, vsync: this);
    _tabController.addListener(_setActiveTabIndex);

    Future.delayed(Duration.zero, () {
      walletStore.getWallet();
      controller.addOnBottomNavigationBarChanged((index) {
        if (mounted) {
          //TODO: Avaliar initstate da tela de wallet
          if (index == PageViewController.TAB_INDEX_MARKETPLACE) {
            _performAllRequests();
          }
          setState(() {});
        }
      });
    });
  }

  Future<void> _performAllRequests() async {
    await walletStore.getWallet();

    switch (_activeTabIndex) {
      case 0:
        await walletStore.getWalletTransfersHistory(0); //all
        break;
      case 1:
        await walletStore.getWalletTransfersHistory(0, "received"); //received
        break;
      case 2:
        await walletStore.getWalletTransfersHistory(0, "sent"); //sent
        break;
    }

    setState(() {});
  }

  void _setActiveTabIndex() {
    setState(() {
      _activeTabIndex = _tabController.index;
    });
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
                          controller: _tabController,
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
                      height: MediaQuery.of(context).size.height * 0.62,
                      child: TabBarView(
                        controller: _tabController,
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
