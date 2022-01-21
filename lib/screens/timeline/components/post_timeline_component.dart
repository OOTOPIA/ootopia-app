import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/bloc/post/post_bloc.dart';
import 'package:ootopia_app/data/models/timeline/like_post_result_model.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/wallet_transfers_repository.dart';
import 'package:ootopia_app/data/utils/fetch-data-exception.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/components/dialog_confirm.dart';
import 'package:ootopia_app/screens/components/popup_menu_post.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/screens/timeline/components/comments/comment_screen.dart';
import 'package:ootopia_app/screens/timeline/components/custom_snackbar_widget.dart';
import 'package:ootopia_app/screens/timeline/components/post_timeline_component_controller.dart';
import 'package:ootopia_app/screens/timeline/components/post_timeline_controller.dart';
import 'package:ootopia_app/screens/timeline/timeline_store.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/custom_scrollbar_widget.dart';
import 'package:ootopia_app/shared/expanded_text.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/link_rich_text.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

import 'feed_player/multi_manager/flick_multi_manager.dart';
import 'feed_player/multi_manager/flick_multi_player.dart';
import 'image_post_timeline_component.dart';

// ignore: must_be_immutable
class PhotoTimeline extends StatefulWidget {
  final int? index;
  final TimelinePost post;
  final TimelineStore timelineStore;
  final User? user;
  bool loggedIn = false;
  final FlickMultiManager flickMultiManager;
  bool isProfile;
  Function onDelete;

  PhotoTimeline({
    required Key key,
    this.index,
    required this.post,
    required this.timelineStore,
    required this.loggedIn,
    this.user,
    required this.flickMultiManager,
    required this.isProfile,
    required this.onDelete,
  }) : super(key: key);

  @override
  _PhotoTimelineState createState() => _PhotoTimelineState(
        post: this.post,
        timelineStore: this.timelineStore,
        loggedIn: this.loggedIn,
        user: this.user,
      );
}

class _PhotoTimelineState extends State<PhotoTimeline> with SecureStoreMixin {
  TimelinePost post;
  final TimelineStore timelineStore;
  WalletTransfersRepositoryImpl walletTransferRepositoryImpl =
      WalletTransfersRepositoryImpl();

  late WalletStore walletStore;
  late PostBloc postBloc;
  bool loggedIn = false;
  User? user;
  bool isUserOwnsPost = false;
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();

  final currencyFormatter = NumberFormat('#,##0.00', 'ID');

  _PhotoTimelineState({
    required this.post,
    required this.timelineStore,
    required this.loggedIn,
    this.user,
  });

  bool dragging = false;

  bool _isDragging = false;
  double _draggablePositionX = 0;
  late Timer _onDragCanceledTimer;
  double oozGoal = 1;
  bool _sendOOZIsLoading = false;
  bool _oozIsSent = false;
  bool _oozError = false;
  String _oozErrorMessage = "";
  bool _oozSlidingOut = false;
  late AuthStore authStore;

  GlobalKey _slideButtonKey = GlobalKey();
  GlobalKey _oozInfoKey = GlobalKey();
  bool _dontAskToConfirmGratitudeReward = false;

  late PostTimelineComponentController postTimelineComponentController;

  late PostTimelineController postTimelineController;
  bool _bigLikeShowAnimation = false;
  bool _bigLikeShowAnimationEnd = true;
  bool canDoubleClick = true;
  SmartPageController controller = SmartPageController.getInstance();

  @override
  void initState() {
    super.initState();
    _checkUserIsLoggedIn();
    _getTransferOozToPostLimitConfig();
    postBloc = BlocProvider.of<PostBloc>(context);
    if (this.post.oozToTransfer == null) {
      this.post.oozToTransfer = 0;
    }
    postTimelineController = PostTimelineController(post: this.post);
  }

  void _checkUserIsLoggedIn() async {
    loggedIn = await getUserIsLoggedIn();
    if (loggedIn) {
      user = await getCurrentUser();
      _dontAskToConfirmGratitudeReward =
          user!.dontAskAgainToConfirmGratitudeReward == null
              ? false
              : user!.dontAskAgainToConfirmGratitudeReward!;
      if (postTimelineComponentController.askToConfirmGratitude == false)
        postTimelineComponentController
            .setAskToConfirmGratitude(_dontAskToConfirmGratitudeReward);
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  void _getTransferOozToPostLimitConfig() async {
    oozGoal = await getTransferOOZToPostLimit();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _goToProfile() async {
    controller.insertPage(ProfileScreen(
      {
        "id": user != null && post.userId == user!.id ? null : post.userId,
      },
    ));
  }

  _popupMenuReturn(String selectedOption) {
    if (selectedOption == 'Excluir' || selectedOption == 'Delete') {
      _showMyDialog();
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return DialogConfirm(
          textAlert:
              AppLocalizations.of(context)!.doYouReallyWantToDeleteYourPost,
          callbackConfirmAlertDialog: _deletePost,
        );
      },
    );
  }

  _deletePost() async {
    //postBloc.add(DeletePostEvent(this.post.id, widget.isProfile));
    await timelineStore.removePost(this.post);
    widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);
    walletStore = Provider.of<WalletStore>(context);
    postTimelineComponentController =
        Provider.of<PostTimelineComponentController>(context);
    return Observer(
      builder: (_) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _goToProfile(),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 6.0,
                        right: 6.0,
                        bottom: 6.0,
                      ),
                      child: this.post.photoUrl != null
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage("${this.post.photoUrl}"),
                              radius: 16,
                            )
                          : CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/icons/user.png"),
                              radius: 16,
                            ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          this.post.username,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Visibility(
                          visible: (this.post.city != null &&
                                  this.post.city!.isNotEmpty) ||
                              (this.post.state != null &&
                                  this.post.state!.isNotEmpty),
                          child: Text(
                            '${this.post.city}' +
                                (this.post.state != null &&
                                        this.post.state!.isNotEmpty
                                    ? ', ${this.post.state}'
                                    : ''),
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (this.post.badges!.length > 0)
                    GestureDetector(
                        child: Container(
                            width: 25,
                            height: 25,
                            child: Image.network(
                                this.post.badges?[0].icon as String)),
                        onTap: () {
                          showModalBottomSheet(
                              barrierColor: Colors.black.withAlpha(1),
                              context: context,
                              backgroundColor: Colors.black.withAlpha(1),
                              builder: (BuildContext context) {
                                return SnackBarWidget(
                                    menu: AppLocalizations.of(context)!
                                        .badgeChangeMakerPro,
                                    text: AppLocalizations.of(context)!
                                        .theChangeMakerProBadgeIsAwardedToIndividualsAndOrganizationsThatAreLeadingConsistentWorkToHelpRegeneratePlanetEarth,
                                    buttons: [
                                      ButtonSnackBar(
                                        text: AppLocalizations.of(context)!
                                            .learnMore,
                                        onTapAbout: () {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                            PageRoute.Page.homeScreen.route,
                                            (Route<dynamic> route) => false,
                                            arguments: {
                                              "returnToPageWithArgs": {
                                                'currentPageName':
                                                    "learning_tracks"
                                              }
                                            },
                                          );
                                        },
                                      )
                                    ],
                                    marginBottom: true,
                                    contact: {
                                      "text": AppLocalizations.of(context)!
                                          .areYouAChangeMakerProToo,
                                      "textLink": AppLocalizations.of(context)!
                                          .getInContact,
                                    });
                              });
                        }),
                  PopupMenuPost(
                    isAnabled: isUserOwnsPost,
                    callbackReturnPopupMenu: _popupMenuReturn,
                    post: post,
                  ),
                ],
              )
            ],
          ),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Color(0xff1A4188),
                  image:  DecorationImage(
                    image: AssetImage(
                      'assets/images/Textura_azul_escuro.png',
                    ),
                    alignment: Alignment.bottomLeft,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: const ScrollBehavior()
                              .copyWith(overscroll: false),
                          child: MyScrollbar(
                            thumbColor: Color(0xff03145C),
                            trackColor: Color(0xff4D7BC9),
                            thickness: 4,
                            builder: (context, scrollController) =>
                                ListView.builder(
                              controller: scrollController,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(left: 15),
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: this.post.tags.length,
                              itemBuilder: (ctx, index) {
                                return Opacity(
                                  opacity: 0.8,
                                  child: HashtagName(
                                    hashtagName: this.post.tags[index],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0.2,
                top: 4,
                child: Container(
                  height: 20,
                  width: 20.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0.2,
                top: 4,
                child: Container(
                  height: 20,
                  width: 20.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                    ),
                  ),
                ),
              )
            ],
          ),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color(0xff1A4188),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: this.post.type == "image"
                    ? ImagePostTimeline(
                        image: this.post.imageUrl as String,
                        onDoubleTapVideo: () => this._likePost(false, true),
                      )
                    : FlickMultiPlayer(
                        userId: (user != null ? user!.id : null),
                        postId: this.post.id,
                        url: this.post.videoUrl!,
                        flickMultiManager: widget.flickMultiManager,
                        image: this.post.thumbnailUrl,
                        onDoubleTapVideo: () => this._likePost(false, true),
                      ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    height: _bigLikeShowAnimation && !_bigLikeShowAnimationEnd
                        ? 100
                        : 0.0,
                    width: _bigLikeShowAnimation && !_bigLikeShowAnimationEnd
                        ? 100
                        : 0.0,
                    curve: _bigLikeShowAnimation &&
                            !_bigLikeShowAnimationEnd &&
                            canDoubleClick
                        ? Curves.easeOutBack
                        : Curves.easeIn,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    duration: const Duration(milliseconds: 300),
                    child: AnimatedOpacity(
                      opacity:
                          _bigLikeShowAnimation && !_bigLikeShowAnimationEnd
                              ? 0.8
                              : 0.0,
                      duration: Duration(milliseconds: 300),
                      child: Visibility(
                        visible: _bigLikeShowAnimation,
                        child: Image.asset(
                          'assets/icons_profile/woow_90_deg.png',
                          width:
                              _bigLikeShowAnimation && !_bigLikeShowAnimationEnd
                                  ? 100
                                  : 0.0,
                          height:
                              _bigLikeShowAnimation && !_bigLikeShowAnimationEnd
                                  ? 100
                                  : 0.0,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 32,
            width: double.infinity,
            margin: EdgeInsets.symmetric(
                vertical: GlobalConstants.of(context).spacingSmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Stack(
              key: _slideButtonKey,
              children: [
                Positioned(
                  left: 54,
                  child: Opacity(
                    opacity: (1.2 -
                                ((((_draggablePositionX * 100) / 300) / 100)) -
                                0.2) >
                            0
                        ? 1.2 -
                            ((((_draggablePositionX * 100) / 300) / 100)) -
                            0.2
                        : 0,
                    child: Container(
                      height: 32,
                      padding: EdgeInsets.only(bottom: 2),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!
                            .slideToGiveAGratitudeReward,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(
                            0xffBEBDBD,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  key: _oozInfoKey,
                  width: 150,
                  right: 0,
                  child: Container(
                    height: 36,
                    margin: EdgeInsets.all(2),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          width: 96,
                          right: showOozToTransfer() ? 50 : 0,
                          child: this.post.oozToTransfer! > 0 &&
                                  (_isDragging || _oozIsSent || _oozError) &&
                                  !_oozSlidingOut
                              ? Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: renderRewardStatus(),
                                )
                              : Container(),
                        ),
                        Visibility(
                          visible: showOozToTransfer(),
                          child: Positioned(
                            height: 26,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    PageRoute.Page.aboutOOzCurrentScreen.route);
                              },
                              child: Container(
                                  width: 80,
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 3),
                                        child: this.post.oozToTransfer == 0
                                            ? Image(
                                                image: AssetImage(
                                                  this.post.oozRewarded ==
                                                              null ||
                                                          this
                                                                  .post
                                                                  .oozRewarded ==
                                                              0
                                                      ? 'assets/icons/ooz_only.png'
                                                      : 'assets/icons/ooz_only_active.png',
                                                ),
                                                width: 16,
                                              )
                                            : Image(
                                                image: AssetImage(
                                                  'assets/icons/ooz_only_active.png',
                                                ),
                                                width: 16,
                                              ),
                                      ),
                                      this.post.oozToTransfer! > 0
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(right: 4),
                                              child: Text(
                                                "+ " +
                                                    currencyFormatter.format(
                                                        this
                                                            .post
                                                            .oozToTransfer),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color(0xFF003694),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  EdgeInsets.only(right: 4),
                                              child: Text(
                                                currencyFormatter.format(
                                                    double.parse(this
                                                        .post
                                                        .oozTotalCollected)),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: this.post.oozRewarded ==
                                                              null ||
                                                          this
                                                                  .post
                                                                  .oozRewarded ==
                                                              0
                                                      ? Colors.black
                                                      : Color(0xFF003694),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: _isDragging ? _draggablePositionX : 64,
                  height: 36,
                  decoration: _draggablePositionX > 36
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Color(0xFF003286),
                            ],
                          ),
                      image:  DecorationImage(
                        image: AssetImage(
                          'assets/images/Textura_azul_escuro.png',
                        ),
                        alignment: Alignment.bottomLeft,
                        fit: BoxFit.none,
                        opacity: 0.4
                      )
                        )
                      : BoxDecoration(),
                ),
                Container(
                  width: _isDragging
                      ? (_draggablePositionX >= 36
                          ? _draggablePositionX + 36
                          : 80)
                      : 64,
                  height: 30,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        child: SizedBox(),
                      ),
                      Positioned(
                        left: _draggablePositionX >= 36 ? _draggablePositionX -36 : 0,
                          child: Container(
                            height: 30,
                            width: 50,
                            decoration: BoxDecoration(
                                image:  DecorationImage(
                                    image: AssetImage(
                                      'assets/icons/button_rectangular.png',
                                    ),
                                    alignment: Alignment.bottomLeft,
                                    fit: BoxFit.fitHeight,
                                )
                            ),
                          )),
                      //
                      Positioned(
                        top: 6,
                        left: _draggablePositionX >= 36
                            ? _draggablePositionX - 22
                            : 12,
                        child: Visibility(
                          visible: _isDragging,
                          child: Image(
                            image: AssetImage(
                              !this.postTimelineController.post.liked
                                  ? 'assets/icons_profile/woow.png'
                                  : 'assets/icons_profile/woow_active.png',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left:
                      _draggablePositionX >= 36 ? _draggablePositionX - 36 : 0,
                  child: Draggable(
                    onDragStarted: () {
                      setState(() {
                        _isDragging = true;
                      });
                    },
                    onDraggableCanceled: (velocity, offset) {},
                    onDragUpdate: (details) {
                      if (this.mounted) {
                        setState(() {
                          if (details.localPosition.dx <= getMaxSlideWidth()) {
                            _draggablePositionX = details.localPosition.dx;
                          } else {
                            if (details.localPosition.dx <= 36) {
                              _draggablePositionX = 36;
                            } else {
                              _draggablePositionX = getMaxSlideWidth();
                            }
                          }
                          onSlideButton();
                        });
                      }
                    },
                    axis: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      height: 30.0, // you can adjust the width as you need
                      child: Opacity(
                        opacity: 1.0,
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: RotatedBox(
                              quarterTurns: 1,
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Image(
                                  image: AssetImage(
                                      'assets/icons_profile/woow.png'),
                                ),
                                onPressed: () => incrementOozToTransfer(),
                              )),
                        ),
                      ),
                    ),
                    feedback: Container(),
                  ),
                ),
                Visibility(
                  visible:
                      this.post.userId == (authStore.currentUser?.id ?? ""),
                  child: GestureDetector(
                    onHorizontalDragEnd: (_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackbars(context).defaultSnackbar(
                          text:
                              AppLocalizations.of(context)!.tooltipBlockedField,
                          backgroundColor: Color(0xff03DAC5),
                          iconColor: Colors.white,
                          suffixIcon: Icons.info_outline_rounded,
                          textColor: Colors.white,
                        ),
                      );
                    },
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackbars(context).defaultSnackbar(
                          text:
                              AppLocalizations.of(context)!.tooltipBlockedField,
                          backgroundColor: Color(0xff03DAC5),
                          iconColor: Colors.white,
                          suffixIcon: Icons.info_outline_rounded,
                          textColor: Colors.white,
                        ),
                      );
                    },
                    child: Container(
                        height: 36,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white.withOpacity(0.5),
                        )),
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: this.post.description.isNotEmpty,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 3,  bottom: 12),
              child: ExpandableText(this.post.description, 3),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.insertPage(
                CommentScreen({
                  "post": this.post,
                }),
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 12, left: 12),
                        child: Text(
                          this.post.commentsCount.toString() +
                              " ${AppLocalizations.of(context)!.comments}",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.4)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: widget.user?.photoUrl != null
                            ? CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage("${widget.user?.photoUrl}"),
                                  radius: 14,
                                ),
                              )
                            : CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/icons/user.png"),
                                  radius: 14,
                                ),
                              ),
                      ),
                      Opacity(
                        opacity: .4,
                        child: Text(
                          AppLocalizations.of(context)!.addAComment,
                          style: TextStyle(),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void incrementOozToTransfer() {
    if (this.post.oozToTransfer == null) {
      this.post.oozToTransfer = 0;
    }
    if (this.post.oozToTransfer! < 0) {
      this.post.oozToTransfer = 0;
    }
    double maxValue = ((oozGoal * (100 - 30)) / 70).roundToDouble();
    if (this.post.oozToTransfer! < maxValue - 5) {
      this.post.oozToTransfer = this.post.oozToTransfer! + 5;
    } else {
      this.post.oozToTransfer = maxValue;
    }
    double perc = ((this.post.oozToTransfer! * 70) / oozGoal) + 30;
    setState(() {
      _isDragging = true;
      _draggablePositionX = (perc * getMaxSlideWidth()) / 100;
    });
  }

  _showConfirmGratitudeReward() {
    var dontAskIsChecked = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GratitudeRewardDialog(
          title: AppLocalizations.of(context)!.gratitudeReward,
          message:
              '${AppLocalizations.of(context)!.doYouConfirmSending} ${this.post.oozToTransfer!.toStringAsFixed(2)} OOZ ${AppLocalizations.of(context)!.fromYourAccontToTheCreatorOfThisPost}',
          onCheckChanged: (bool isChecked) {
            setState(() {
              dontAskIsChecked = isChecked;
            });
          },
          onClickPositiveButton: () {
            this._dontAskToConfirmGratitudeReward = dontAskIsChecked;
            postTimelineComponentController
                .setAskToConfirmGratitude(_dontAskToConfirmGratitudeReward);
            sendOOZ();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Widget renderRewardStatus() {
    if (_oozIsSent || _oozError) {
      return Container(
        width: 26,
        height: 26,
        decoration: (_oozError
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                shape: BoxShape.rectangle,
                color: Color(0xffDD0606),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              )),
        child: IconButton(
          padding: EdgeInsets.all(0),
          icon: (_oozError
              ? Icon(Icons.info, color: Colors.white, size: 24)
              : Icon(Icons.check, color: Colors.green.shade600, size: 24)),
          onPressed: () {},
        ),
      );
    }
    return SizedBox(
      height: 25,
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.black87,
          padding: EdgeInsets.only(left: 12),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          backgroundColor: Color(0xFF03DAC5),
          alignment:
              showOozToTransfer() ? Alignment.centerLeft : Alignment.center,
        ),
        onPressed: () {
          if (!loggedIn) {
            Navigator.of(context).pushNamed(
              PageRoute.Page.loginScreen.route,
            );
          } else if (!_sendOOZIsLoading) {
            if (postTimelineComponentController.askToConfirmGratitude) {
              sendOOZ();
            } else {
              _showConfirmGratitudeReward();
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.only(
            left: 6,
          ),
          child: !_sendOOZIsLoading
              ? Text(
                  AppLocalizations.of(context)!.send,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                )
              : SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
        ),
      ),
    );
  }

  void sendOOZ() async {
    setState(() {
      _sendOOZIsLoading = true;
    });
    try {
      await this.walletTransferRepositoryImpl.transferOOZToPost(this.post.id,
          this.post.oozToTransfer!, this._dontAskToConfirmGratitudeReward);
      this.trackingEvents.timelineDonatedOOZ();
      await this.walletStore.getWallet();
      setState(() {
        _sendOOZIsLoading = false;
        this.post.oozTotalCollected =
            "${(double.parse(this.post.oozTotalCollected) + this.post.oozToTransfer!)}";
        if (this.post.oozRewarded == null || this.post.oozRewarded == 0) {
          this.post.oozRewarded = this.post.oozToTransfer;
        } else {
          this.post.oozRewarded =
              this.post.oozRewarded! + this.post.oozToTransfer!;
        }
      });
      _showOOZIsSent();
    } on FetchDataException catch (e) {
      String errorMessage = e.toString();
      print("Error: ${e.toString()}");
      setState(() {
        _sendOOZIsLoading = false;
        _oozError = true;
        _oozErrorMessage =
            AppLocalizations.of(context)!.anErrorHasOccurredTryAgain;
        if (errorMessage == "INSUFFICIENT_BALANCE") {
          _oozErrorMessage =
              AppLocalizations.of(context)!.yourHaveInsufficientOOZToGive;
        }
        showOOZErrorMessage();
      });
    }
  }

  void showOOZErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              12,
            ),
          ),
        ),
        elevation: 3,
        duration: Duration(seconds: 30),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.info_rounded,
              color: Color(0xffDD0606),
              size: 26,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: GlobalConstants.of(context).spacingSmall,
              ),
              child: Text(
                _oozErrorMessage,
                style: TextStyle(color: Colors.black87),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.close,
                ),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Timer(Duration(seconds: 1), () {
      setState(() {
        _oozError = false;
      });
      resetSlideButton();
    });
  }

  void _showOOZIsSent() {
    setState(() {
      _oozIsSent = true;
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        _oozIsSent = false;
      });
      resetSlideButton();
    });
  }

  double getMaxSlideWidth() {
    final RenderBox renderBox =
        _slideButtonKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox renderBoxOOZInfo =
        _oozInfoKey.currentContext!.findRenderObject() as RenderBox;
    return (renderBox.size.width - renderBoxOOZInfo.size.width) - 26;
  }

  void onSlideButton() {
    double perc = (_draggablePositionX * 100) / getMaxSlideWidth();
    if (_draggablePositionX > 30) {
      this.post.oozToTransfer = ((oozGoal * (perc - 30)) / 70).roundToDouble();
    } else {
      this.post.oozToTransfer = 0.0;
    }
  }

  bool showOozToTransfer() {
    return !_oozIsSent && !_oozError && !_sendOOZIsLoading;
  }

  void resetSlideButton() {
    setState(() {
      _oozSlidingOut = true;
    });
    _onDragCanceledTimer = Timer.periodic(Duration(milliseconds: 1), (Timer t) {
      setState(() {
        _draggablePositionX = _draggablePositionX - 3;
        if (_draggablePositionX <= 0) {
          _draggablePositionX = 0;
          _onDragCanceledTimer.cancel();
          _isDragging = false;
          _oozSlidingOut = false;
        }
        onSlideButton();
      });
    });
  }

  void _likePost(bool dislikeIfIsLiked, [bool? showAnimation]) async {
    if (canDoubleClick) {
      incrementOozToTransfer();
      setState(() {
        canDoubleClick = false;
      });
      Future.delayed(Duration(milliseconds: 450), () {
        setState(() {
          _bigLikeShowAnimationEnd = true;
        });
      });
      Future.delayed(Duration(milliseconds: 600), () {
        setState(() {
          canDoubleClick = true;
        });
      });

      if (!loggedIn) {
        Navigator.of(context).pushNamed(
          PageRoute.Page.loginScreen.route,
        );
      } else {
        if (showAnimation == true) {
          this._showBigLike();
        }
        if (dislikeIfIsLiked ||
            (!this.postTimelineController.post.liked && !dislikeIfIsLiked)) {
          LikePostResult likePostResult =
              await this.postTimelineController.likePost();
          setState(
            () {
              if (likePostResult.liked) {
                this.trackingEvents.timelineGaveALike(
                  {
                    "userId": this.post.userId,
                  },
                );
              } else if (this.post.likesCount > 0) {
                this.trackingEvents.timelineGaveADislike(
                  {
                    "userId": this.post.userId,
                  },
                );
              }
            },
          );
        }
      }
    }
  }

  void _showBigLike() {
    setState(() {
      _bigLikeShowAnimation = true;
      _bigLikeShowAnimationEnd = false;
    });
  }
}

class GratitudeRewardDialog extends StatefulWidget {
  String title;
  String message;
  Function onClickPositiveButton;
  Function onCheckChanged;

  GratitudeRewardDialog({
    required this.title,
    required this.message,
    required this.onClickPositiveButton,
    required this.onCheckChanged,
    Key? key,
  }) : super(key: key);

  @override
  _GratitudeRewardDialogState createState() => _GratitudeRewardDialogState(
        title: this.title,
        message: this.message,
        onClickPositiveButton: this.onClickPositiveButton,
        onCheckChanged: this.onCheckChanged,
      );
}

class _GratitudeRewardDialogState extends State<GratitudeRewardDialog> {
  String title;
  String message;
  Function onClickPositiveButton;
  Function onCheckChanged;
  bool _isChecked = false;

  _GratitudeRewardDialogState({
    required this.title,
    required this.message,
    required this.onClickPositiveButton,
    required this.onCheckChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        this.title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline2!.copyWith(
              color: Colors.black87,
            ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              bottom: GlobalConstants.of(context).spacingNormal,
            ),
            child: Text(
              this.message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: Colors.black87,
                  ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () => this.onClickPositiveButton(),
                elevation: 0,
                color: Color(0xff62c915),
                child: Text(
                  AppLocalizations.of(context)!.confirm,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: GlobalConstants.of(context).spacingSmall,
                ),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  elevation: 0,
                  color: Color(0xffd40016),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              setState(() {
                _isChecked = !_isChecked;
              });
              if (this.onCheckChanged != null) {
                this.onCheckChanged(this._isChecked);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = !_isChecked;
                    });
                    if (this.onCheckChanged != null) {
                      this.onCheckChanged(this._isChecked);
                    }
                  },
                ),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.dontShowThisMessageAgain,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HashtagName extends StatelessWidget {
  String hashtagName;

  HashtagName({required this.hashtagName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3),
      padding: EdgeInsets.all(4),
      child: Center(
        child: Text(
          "#$hashtagName",
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class CustomContainerShapeBorder extends CustomPainter {
  final double x;

  CustomContainerShapeBorder({this.x = 0});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue.shade900;

    double calcPosition = x >= 36 ? x - 36 : 0;

    canvas.translate(calcPosition, 0);

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTRB(
          0,
          0,
          32,
          30,
        ),
        bottomLeft: Radius.circular(100),
        topLeft: Radius.circular(100),
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
      paint,
    );

    canvas.translate(31, 0);

    var path = Path();
    path.lineTo(0, 15);
    path.lineTo(15, 15);
    path.close();
    canvas.drawPath(path, paint);

    var path2 = Path();
    path2.lineTo(15, 15);
    path2.lineTo(0, 30);
    path2.close();
    canvas.drawPath(path2, paint);
    //var path = createPath(3, 36);
    //canvas.drawPath(path, paint..color = Colors.green);
    //canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Path createPath(int sides, double radius) {
    var path = Path();
    var angle = (math.pi * 2) / sides;
    path.moveTo(radius * math.cos(0.0), radius * math.sin(0.0));
    for (int i = 1; i <= sides; i++) {
      double x = radius * math.cos(angle * i);
      double y = radius * math.sin(angle * i);
      path.lineTo(x, y);
    }
    path.close();
    return path;
  }
}

// Usar caso seja necessário no futuro, atualmente o player do youtube será desabilitado
// YoutubePlayer(
//   controller: _controller,
//   showVideoProgressIndicator: true,
//   onReady: () {
//     print("ready!!");
//     _isPlayerReady = true;
//     //_controller.addListener(listener);
//   },
// )
