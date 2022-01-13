import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/screens/components/information_widget.dart';
import 'package:ootopia_app/screens/components/try_again.dart';
import 'package:ootopia_app/screens/learning_tracks/learning_tracks_store.dart';
import 'package:ootopia_app/screens/learning_tracks/view_learning_tracks/view_learning_tracks.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/screens/marketplace/components/components.dart';
import 'package:ootopia_app/screens/marketplace/marketplace_store.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  void initState() {
    super.initState();
    marketplaceStore.getProductList(
        limit: marketplaceStore.itemsPerPageCount, offset: 0);
    pageController = SmartPageController.getInstance();
    _scrollController.addListener(
      () => marketplaceStore.updateOnScroll(_scrollController),
    );
    Future.delayed(Duration.zero).then((value) async {
      walletStore.getWallet();
      welcomeGuideLearningTrack = await learningTracksStore.getWelcomeGuide();
    });
  }

  @override
  Widget build(BuildContext context) {
    walletStore = Provider.of<WalletStore>(context);
    return RefreshIndicator(
      onRefresh: () async {
        await walletStore.getWallet();
        await marketplaceStore.refreshData();
      },
      child: Scaffold(
        body: Stack(
          children: [
            BackgroundButterflyTop(positioned: -59),
            BackgroundButterflyBottom(positioned: -50),
            body()
          ],
        ),
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
        return LoadingOverlay(
          isLoading: marketplaceStore.viewState == ViewState.loading,
          child: Provider(
            create: (_) => marketplaceStore,
            child: Column(
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
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 50,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            direction: Axis.horizontal,
                            children: [
                              ...productList(marketplaceStore.productList),
                              Visibility(
                                visible: marketplaceStore.viewState !=
                                    ViewState.loading &&
                                    marketplaceStore.viewState !=
                                        ViewState.refresh,
                                child: CreateOfferButtonWidget(onTap: () {
                                  Navigator.of(context).pushNamed(PageRoute
                                      .Page.aboutEthicalMarketPlace.route);
                                }),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: marketplaceStore.viewState ==
                                ViewState.loadingNewData,
                            child:
                            Center(child: CircularProgressIndicator()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> productList(List<dynamic> list) =>
      list.map((product) => ProductItem(productModel: product)).toList();

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
}
