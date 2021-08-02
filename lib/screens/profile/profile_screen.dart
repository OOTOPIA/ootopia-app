import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/wallets/wallet_model.dart';
import 'package:ootopia_app/data/repositories/wallet_repository.dart';
import 'package:ootopia_app/screens/profile/components/tab_all_component.dart';
import 'package:ootopia_app/screens/profile/components/tab_received_component.dart';
import 'package:ootopia_app/screens/profile/components/tab_send_component.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  WalletRepositoryImpl walletRepositoryImpl = WalletRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(),
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
                          'OOz Total Balance',
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
                            width: 50,
                            child: FutureBuilder<Wallet>(
                                future: walletRepositoryImpl.getWallet(
                                    '19dce8cb-358b-4765-93e4-d1d581b75675'),
                                builder: (context, snapshot) {
                                  return Text(
                                    '${snapshot.data?.totalBalance}',
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
                      'This is your OOz wallet. Here you can check your total \n balance and all incoming and outcoming transactions',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'Learn More',
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
                        text: 'All',
                      ),
                      Tab(
                        text: 'Received',
                      ),
                      Tab(
                        text: 'Sent',
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.61,
                child: TabBarView(
                  children: [
                    TabAllComponent(
                      walletRepositoryImpl: walletRepositoryImpl,
                    ),
                    TabReceivedComponent(
                      walletRepositoryImpl: walletRepositoryImpl,
                    ),
                    TabSendComponent(
                      walletRepositoryImpl: walletRepositoryImpl,
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
}
