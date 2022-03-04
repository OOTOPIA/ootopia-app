import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/data/models/general_config/general_config_model.dart';
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'package:ootopia_app/data/models/post/post_create_model.dart';
import 'package:ootopia_app/data/repositories/interests_tags_repository.dart';
import 'package:ootopia_app/screens/camera_screen/custom_gallery/components/media_view_widget.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/screens/components/try_again.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/post_preview_screen/components/confirm_post_button_widget.dart';
import 'package:ootopia_app/screens/post_preview_screen/components/hashtag_select_search_dialog_widget.dart';
import 'package:ootopia_app/screens/post_preview_screen/components/post_preview_screen_store.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/multi_manager/flick_multi_manager.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/geolocation.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/rich_text_controller.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'dart:math' as math;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostPreviewPage extends StatefulWidget {
  Map<String, dynamic> args;
  PostPreviewPage(this.args);

  @override
  _PostPreviewPageState createState() => _PostPreviewPageState();
}

class _PostPreviewPageState extends State<PostPreviewPage>
    with SecureStoreMixin, WidgetsBindingObserver {
  FlickManager? flickManager;
  late VideoPlayerController videoPlayer;
  late FlickMultiManager flickMultiManager;
  InterestsTagsRepositoryImpl _tagsRepository = InterestsTagsRepositoryImpl();
  late RichTextController _descriptionInputController;
  final TextEditingController _geolocationInputController =
      TextEditingController();
  double mirror = 0;
  late HomeStore homeStore;
  late WalletStore walletStore;
  late PostPreviewScreenStore postPreviewStore;

  bool _isLoading = true;
  bool _errorOnGetTags = false;
  bool _createdPost = false;
  bool _processingVideoInBackground = false;
  bool _processingVideoInBackgroundError = false;
  bool _readyToSendPost =
      false; //Será "true" quando o usuário tentar enviar um vídeo que está sendo processado em background com o ffmpeg
  String geolocationErrorMessage = "";
  String geolocationMessage = "Please, wait...";
  String tagsErrorMessage = "";
  Image? image;
  Size? imageSize;
  String currenLocalization = '';
  String conditional = "";
  List filteredList = [];
  SecureStoreMixin secureStoreMixin = SecureStoreMixin();
  final pageController = SmartPageController.getInstance();
  bool sendingPost = false;

  PostCreate postData = PostCreate();

  List<MultiSelectItem<InterestsTagsModel>> _items = [];

  List<InterestsTagsModel> _selectedTags = [];

  Future<void> _getTags() async {
    setState(() {
      _isLoading = true;
      _errorOnGetTags = false;
    });

    currenLocalization = Platform.localeName.substring(0, 2);

    this._tagsRepository.getTags(currenLocalization).then((tags) {
      setState(() {
        _isLoading = false;
        _items = tags
            .map((tag) => MultiSelectItem<InterestsTagsModel>(tag, tag.name))
            .toList();
      });
    }).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
        _errorOnGetTags = true;
      });
    });
  }

  void _getLocation(context) {
    setState(() {
      geolocationErrorMessage = "";
      geolocationMessage = AppLocalizations.of(context)!.pleaseWait;
    });
    Geolocation.determinePosition(context).then((Position position) async {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      setState(() {
        if (placemarks.length > 0) {
          var placemark = placemarks[0];
          _geolocationInputController.text =
              "${placemark.subAdministrativeArea}, ${placemark.administrativeArea} - ${placemark.country}";

          postData.addressCity = placemark.subAdministrativeArea != null
              ? placemark.subAdministrativeArea!
              : "";
          postData.addressState = placemark.administrativeArea != null
              ? placemark.administrativeArea!
              : "";
          postData.addressCountryCode =
              placemark.isoCountryCode != null ? placemark.isoCountryCode! : "";
          postData.addressLatitude = position.latitude;
          postData.addressLongitude = position.longitude;
          postData.addressNumber =
              placemark.name != null ? placemark.name! : "";
        } else {
          geolocationMessage =
              AppLocalizations.of(context)!.failedToGetCurrentLocation;
          geolocationErrorMessage =
              AppLocalizations.of(context)!.weCouldntGetYourLocation2;
        }
      });
    }).onError((error, stackTrace) {
      setState(() {
        geolocationMessage =
            AppLocalizations.of(context)!.failedToGetCurrentLocation;
        geolocationErrorMessage = error.toString();
      });
    });
  }

  Future<bool> _onWillPop(bool isNativeBackButton) async {
    if (_createdPost) {
      return true;
    }
    if (flickManager != null &&
        flickManager!.flickControlManager!.isFullscreen) {
      flickManager!.flickControlManager!.toggleFullscreen();
      return false;
    }
    bool returnDialog = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.discardChanges,
                style: Theme.of(context).textTheme.headline2,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                        AppLocalizations.of(context)!
                            .doYouWantToDiscardTheChanges,
                        style: Theme.of(context).textTheme.bodyText2),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(AppLocalizations.of(context)!.noContinueEditing),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text(AppLocalizations.of(context)!.yes),
                  onPressed: () {
                    postPreviewStore.clearhashtags();
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;

    if (!isNativeBackButton && returnDialog) {
      Navigator.pop(context);
      return false;
    }
    return returnDialog;
  }

  void _sendPost() async {
    if (_processingVideoInBackgroundError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .thereAasAProblemLoadingTheVideoPleaseTryToUploadTheVideoAgain),
        ),
      );
      return;
    }

    if (_selectedTags.length < 1) {
      setState(() {
        tagsErrorMessage =
            AppLocalizations.of(context)!.pleaseSelectAtLeast1Tag;
      });
      return;
    }

    if (sendingPost) {
      return;
    }

    if (_processingVideoInBackground) {
      _readyToSendPost = true;
      postPreviewStore.uploadIsLoading = true;
    }

    postData.tagsIds = _selectedTags.map((tag) => tag.id).toList();
    postData.type = widget.args["type"] == "image" ? "image" : "video";
    postData.description = _descriptionInputController.text;

    if (postData.type == "video") {
      postData.durationInSecs = (flickManager!.flickVideoManager!
                  .videoPlayerValue!.duration.inMilliseconds %
              60000) /
          1000;
    }

    print("ready to start upload");

    GeneralConfigModel? oozToRewardForVideo = await this
        .secureStoreMixin
        .getGeneralConfigByName("creator_reward_per_minute_of_posted_video");
    GeneralConfigModel? oozToRewardForImage = await this
        .secureStoreMixin
        .getGeneralConfigByName("creator_reward_for_posted_photo");
    sendingPost = true;

    try {
      await this.postPreviewStore.createPost(postData,
          oozToRewardForVideo?.value ?? 0, oozToRewardForImage?.value ?? 0);
      sendingPost = false;
      await this.walletStore.getWallet();

      if (this.postPreviewStore.successOnUpload) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          PageRoute.Page.homeScreen.route,
          ModalRoute.withName('/'),
          arguments: {
            "createdPost": true,
            "oozToReward": this.postPreviewStore.oozToReward
          },
        );
      } else if (this.postPreviewStore.errorOnUpload) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!
                .thereWasAProblemUploadingTheVideoPleaseTryToUploadTheVideoAgain
                .replaceAll("video", postData.type!)),
          ),
        );
      }

      postPreviewStore.clearhashtags();
    } catch (err) {
      sendingPost = false;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _getLocation(context);
    });
    super.initState();

    _descriptionInputController = RichTextController(
      deleteOnBack: false,
      patternMatchMap: {
        RegExp(r"((https?:www\.)|(https?:\/\/)|(www\.))?[\w/\-?=%.][-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?"):
            const TextStyle(
          color: LightColors.linkText,
        ),
      },
      onMatch: (List<String> matches) {},
    );

    WidgetsBinding.instance!.addObserver(this);

    flickMultiManager = FlickMultiManager();
    postData.filePath = widget.args["filePath"];
    if (widget.args["type"] == "video") {
      videoPlayer = VideoPlayerController.file(File(widget.args["filePath"]))
        ..setLooping(true);

      flickManager = FlickManager(
        videoPlayerController: videoPlayer,
      );

      flickMultiManager.init(flickManager!);

      flickManager!.flickControlManager!.mute();
    }

    if (widget.args["mirrored"] == "true") {
      mirror = math.pi;
      _processingVideoInBackground = true;
      FlutterFFmpeg _ffmpeg = new FlutterFFmpeg();
      String filePath = widget.args["filePath"];
      filePath = filePath.replaceAll(".mp4", "-updated.mp4");
      postData.filePath = filePath;
      _ffmpeg
          .execute("-y -i " +
              widget.args["filePath"] +
              " -vf hflip -c:v mpeg4 -bf 1 -b:v 2048k " +
              filePath)
          .then((_) {
        if (this.mounted) {
          setState(() {
            _processingVideoInBackground = false;
            if (_readyToSendPost) {
              postPreviewStore.uploadIsLoading = false;
              _readyToSendPost = false;
              _sendPost();
            }
          });
        }
      }).catchError((onError) {
        _processingVideoInBackground = false;
        _processingVideoInBackgroundError = true;
        if (_readyToSendPost && this.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!
                  .thereWasAProblemUploadingTheVideoPleaseTryToUploadTheVideoAgain),
            ),
          );
          setState(() {
            postPreviewStore.uploadIsLoading = false;
            _readyToSendPost = false;
          });
        }
      });
    }

    if (widget.args["type"] == "image") {
      _getSizeImage();
    }

    _getTags();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (currenLocalization != Platform.localeName.substring(0, 2) &&
        AppLifecycleState.resumed == state) {
      await _getTags();
    }
  }

  @override
  void dispose() {
    if (widget.args["type"] == "video") {
      flickManager!.dispose();
      flickMultiManager.remove(flickManager!);
      videoPlayer.dispose();
    }
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  void _getSizeImage() {
    this.image = Image.file(
      File(widget.args["filePath"]),
      fit: BoxFit.cover,
    );
    this.imageSize = Size(100.toDouble(), 100.toDouble());

    Completer<ui.Image> completer = Completer<ui.Image>();
    this
        .image!
        .image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener(
      (ImageInfo image, bool synchronousCall) {
        this.imageSize =
            Size(image.image.width.toDouble(), image.image.height.toDouble());
        completer.complete(image.image);
        setState(() {});
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    walletStore = Provider.of<WalletStore>(context);
    postPreviewStore = Provider.of<PostPreviewScreenStore>(context);
    return new WillPopScope(
      onWillPop: () => _onWillPop(true),
      child: Scaffold(
        appBar: appbar(),
        body: Stack(
          children: [
            BackgroundButterflyTop(positioned: -59),
            Visibility(
                visible: MediaQuery.of(context).viewInsets.bottom == 0,
                child: BackgroundButterflyBottom()),
            GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
                child: Observer(builder: (_) => body())),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget appbar() => DefaultAppBar(
        components: [
          AppBarComponents.back,
          AppBarComponents.close,
        ],
        onTapLeading: () {
          _onWillPop(false);
        },
        onTapAction: () {
          postPreviewStore.clearhashtags();
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      );

  Widget body() {
    return LoadingOverlay(
        isLoading: postPreviewStore.uploadIsLoading,
        child: Observer(builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(GlobalConstants.of(context).spacingSmall),
              child: Column(
                children: [
                  Container(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: widget.args["type"] == "video"
                            ? MediaQuery.of(context).size.height * .6
                            : MediaQuery.of(context).size.width +
                                GlobalConstants.of(context).spacingNormal * 2,
                      ),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              left: GlobalConstants.of(context).spacingNormal,
                              right: GlobalConstants.of(context).spacingNormal,
                              top: GlobalConstants.of(context).spacingNormal,
                              bottom: GlobalConstants.of(context)
                                  .screenHorizontalSpace,
                            ),
                            child: widget.args["type"] == "video"
                                ? ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(21)),
                                    child: Transform(
                                      alignment: Alignment.center,
                                      child: FlickVideoPlayer(
                                        preferredDeviceOrientationFullscreen: [],
                                        flickManager: flickManager!,
                                        flickVideoWithControls:
                                            FlickVideoWithControls(
                                          controls: null,
                                        ),
                                      ),
                                      transform: Matrix4.rotationY(mirror),
                                    ),
                                  )
                                : Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Color(0xff000000),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        image: DecorationImage(
                                          fit: this.imageSize!.height >
                                                  imageSize!.width
                                              ? BoxFit.fitHeight
                                              : BoxFit.fitWidth,
                                          alignment: FractionalOffset.center,
                                          image: FileImage(
                                              File(widget.args["filePath"])),
                                        )),
                                  ),
                          ),
                          widget.args["type"] == "video"
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(
                                          GlobalConstants.of(context)
                                              .spacingMedium),
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: SizedBox(
                                        width: 28,
                                        height: 28,
                                        child: IconButton(
                                          padding: EdgeInsets.all(0),
                                          icon: Icon(
                                              flickManager!.flickControlManager!
                                                      .isMute
                                                  ? Icons.volume_off
                                                  : Icons.volume_up,
                                              size: 20),
                                          onPressed: () {
                                            setState(() {
                                              //flickMultiManager.toggleMute();
                                              if (!flickManager!
                                                  .flickControlManager!
                                                  .isMute) {
                                                flickManager!
                                                    .flickControlManager!
                                                    .mute();
                                              } else {
                                                flickManager!
                                                    .flickControlManager!
                                                    .unmute();
                                              }
                                            });
                                          },
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: GlobalConstants.of(context).spacingNormal),
                    child: TextFormField(
                      maxLines: null,
                      minLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      controller: _descriptionInputController,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal),
                      autofocus: false,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        hintText:
                            AppLocalizations.of(context)!.writeADescription,
                        hintStyle: TextStyle(
                            color: Colors.black.withOpacity(.3),
                            fontWeight: FontWeight.normal),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: .25),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff707070), width: .25),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff707070), width: .25),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: GlobalConstants.of(context).screenHorizontalSpace,
                  ),
                  Visibility(
                    visible: geolocationErrorMessage.isNotEmpty,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: GlobalConstants.of(context).spacingNormal,
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                GlobalConstants.of(context).spacingNormal),
                        width: double.infinity,

                        child: FlatButton(
                          height: 57,
                          child: Padding(
                            padding: EdgeInsets.all(
                              GlobalConstants.of(context).spacingNormal,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.getCurrentLocation,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          onPressed: () {
                            _getLocation(context);
                          },
                          splashColor: Colors.black54,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Color(0xff707070),
                              width: .25,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: geolocationErrorMessage.isNotEmpty,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: GlobalConstants.of(context).spacingNormal,
                        bottom: GlobalConstants.of(context).spacingSmall,
                        left: GlobalConstants.of(context).screenHorizontalSpace,
                        right:
                            GlobalConstants.of(context).screenHorizontalSpace,
                      ),
                      child: Text(
                        geolocationErrorMessage +
                            AppLocalizations.of(context)!
                                .tryToRetrieveYourCurrentLocationClickingByGetLocationAgain,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: GlobalConstants.of(context).screenHorizontalSpace,
                  ),
                  Visibility(
                      visible: !_errorOnGetTags && !_isLoading,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                GlobalConstants.of(context).spacingNormal),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      HashtagSelectSearchDialogWidget(
                                    items: _items,
                                    postPreviewScreenStore: postPreviewStore,
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    bottom: GlobalConstants.of(context)
                                        .spacingNormal),
                                height: 57,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: LightColors.grey,
                                    width: 0.25,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Image.asset(
                                            "assets/icons/add_icon.png",
                                            height: 24,
                                          ),
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .searchForAtag,
                                          style: GoogleFonts.roboto(
                                              fontSize: 15,
                                              color: LightColors.blackText,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Text(
                                        postPreviewStore.selectedTags.length ==
                                                0
                                            ? ""
                                            : "${postPreviewStore.selectedTags.length} ${postPreviewStore.selectedTags.length > 1 ? AppLocalizations.of(context)!.selecteds : AppLocalizations.of(context)!.selected2}",
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: [
                                  ...postPreviewStore.selectedTags
                                      .map((item) => GestureDetector(
                                            onTap: () {
                                              postPreviewStore.selectedTags
                                                  .remove(item);
                                            },
                                            child: Container(
                                              height: 38,
                                              margin: EdgeInsets.only(
                                                  bottom: GlobalConstants.of(
                                                          context)
                                                      .spacingSmall,
                                                  left: 2),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      GlobalConstants.of(
                                                              context)
                                                          .intermediateSpacing,
                                                  vertical: GlobalConstants.of(
                                                          context)
                                                      .smallIntermediateSpacing),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(35),
                                                  color: LightColors.darkBlue),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 12),
                                                    child: Text(item.name,
                                                        style: GoogleFonts.roboto(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline5!
                                                                .fontSize)),
                                                  ),
                                                  Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 16,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ))
                                      .toList()
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 28),
                              child: ConfirmButtonWidget(
                                  content: Text(
                                    AppLocalizations.of(context)!.publish,
                                    style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    setState(() {
                                      _selectedTags =
                                          postPreviewStore.selectedTags;
                                    });
                                    _sendPost();
                                  }),
                            )
                          ],
                        ),
                      )),
                  Visibility(
                    visible: _errorOnGetTags && !_isLoading,
                    child: Container(
                      width: double.infinity,
                      child: TryAgain(
                        _getTags,
                        showOnlyButton: true,
                        buttonText: AppLocalizations.of(context)!
                            .errorLoadingTagsTryAgain,
                        buttonBackgroundColor: Colors.white,
                        messageTextColor: Colors.white,
                        buttonTextColor: Colors.black,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: tagsErrorMessage.isNotEmpty,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 8,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Text(
                          tagsErrorMessage,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Color(0xff8E1816),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isLoading,
                    child: Center(
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: GlobalConstants.of(context).spacingNormal,
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
