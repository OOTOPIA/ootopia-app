import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/screens/components/information_widget.dart';
import 'package:ootopia_app/screens/components/try_again.dart';
import 'package:ootopia_app/screens/home/home_screen.dart';
import 'package:ootopia_app/screens/learning_tracks/learning_tracks_store.dart';
import 'package:ootopia_app/screens/learning_tracks/view_learning_tracks/view_learning_tracks.dart';
import 'package:ootopia_app/screens/marketplace/components/components.dart';
import 'package:ootopia_app/screens/marketplace/marketplace_store.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class MarketplaceScreen extends StatefulWidget {
  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final marketplaceStore = MarketplaceStore();
  late WalletStore walletStore;
  late SmartPageController pageController;
  final ScrollController _scrollController = ScrollController();
  LearningTracksStore learningTracksStore = LearningTracksStore();
  LearningTracksModel? welcomeGuideLearningTrack;
  final GlobalKey _widgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    marketplaceStore.getProducts();
    pageController = SmartPageController.getInstance();
    _scrollController.addListener(() async {
      if(_scrollController.offset >= _scrollController.position.maxScrollExtent*0.95 &&
          marketplaceStore.canLoadMoreProducts() ){
        await marketplaceStore.getMoreProducts();
      }
    },);
    Future.delayed(Duration.zero).then((value) async {
      walletStore.getWallet();
      welcomeGuideLearningTrack = await learningTracksStore.getWelcomeGuide();
    });
  }

  @override
  Widget build(BuildContext context) {
    walletStore = Provider.of<WalletStore>(context);
    return Scaffold(
      body: Stack(
        children: [
          BackgroundButterflyTop(positioned: -59),
          BackgroundButterflyBottom(positioned: -50),
          body()
        ],
      ),
    );
  }

  Widget body(){
    return Observer(
      builder: (context) {
        if (marketplaceStore.viewState == ViewState.error) {
          return TryAgain(
            marketplaceStore.refreshData,
          );
        }
        else{
          return LoadingOverlay(
            isLoading: marketplaceStore.viewState == ViewState.loading,
            child: Provider(
              create: (_) => marketplaceStore,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Column(
                      key: _widgetKey,
                      children: [
                        InformationWidget(
                          icon: Image.asset(
                            "assets/icons/marketplace_icon_bottomless.png",
                            width: 24,
                          ),
                          title: AppLocalizations.of(context)!.ethicalMarketplace,
                          text: AppLocalizations.of(context)!
                              .ethicalMarketplaceHeaderDescription,
                          onTap: () async {
                            if (welcomeGuideLearningTrack == null) {
                              welcomeGuideLearningTrack =
                              await learningTracksStore.getWelcomeGuide();
                            }
                            if (welcomeGuideLearningTrack != null) {
                              openLearningTrack(welcomeGuideLearningTrack!);
                            }
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        MarketplaceBarWidget(),
                      ],
                    ),
                    Visibility(
                      visible: !marketplaceStore.loadingPage(),
                      child: RefreshIndicator(
                          onRefresh: () async {
                            await marketplaceStore.refreshData();
                            await walletStore.getWallet();
                          },
                          child: listWidget(marketplaceStore.productList)
                      ),

                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget listWidget(List list){
    int itemsPerLine = getItemsPerLine();
    int amount = getSizeOfList(list, itemsPerLine);
    return Container(
        height: MediaQuery.of(context).size.height - (_getHeadSize() ) ,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            controller: _scrollController,
            itemCount: amount,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              bool isLastNine = index + 1 == amount;
              return Empty(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLastNine ? _getHeadSize() : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Wrap(
                        children: [
                          for (int i=0; i < getAmountOfItems(isLastNine, list, itemsPerLine); i++)...[
                            ProductItem(productModel: list[index * itemsPerLine + i]),
                          ],
                          if(isLastNine)...[
                            CreateOfferButtonWidget(
                                topMargin: list.length % itemsPerLine != 0,
                                onTap: () {
                                  Navigator.of(context).pushNamed(PageRoute
                                      .Page.aboutEthicalMarketPlace.route);
                                }),
                            SizedBox(
                              width: _size(itemsPerLine, list),
                            )
                          ]
                        ],
                      ),
                      if(isLastNine && marketplaceStore.loadingMoreItems())...[
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: CircularProgressIndicator(),
                        )
                      ]
                    ],
                  ),
                ),
              );
            })
    );
  }

  void openLearningTrack(LearningTracksModel learningTrack) =>
      pageController.insertPage(ViewLearningTracksScreen(
        {
          'list_chapters': learningTrack.chapters,
          'learning_tracks': learningTrack,
          'updateLearningTrack': () {
            setState(() {});
          },
        },
      ));


  int getItemsPerLine(){
    return MediaQuery.of(context).size.width >= 760 ? 4 : 2;
  }

  int getAmountOfItems(lastNine, list, itemsPerLine) {
    return (lastNine ? list.length % itemsPerLine : itemsPerLine);
  }

  int getSizeOfList(List list,int itemsPerLine ) {
    return list.length % itemsPerLine == 0 ? (list.length/itemsPerLine).round() + 1 : (list.length/itemsPerLine).ceil();
  }

  double _size(int itemsPerLine, list){
    return (MediaQuery.of(context).size.width >= 760
        ? (MediaQuery.of(context).size.width / 4) - 6
        : (MediaQuery.of(context).size.width / 2) - 12) * (itemsPerLine - list.length % itemsPerLine - 1);
  }

  double _getHeadSize() {
    final RenderBox? renderBox = _widgetKey.currentContext?.findRenderObject() as RenderBox?;
    final Size? size = renderBox?.size;
    return size?.height ?? 300;
  }

}
