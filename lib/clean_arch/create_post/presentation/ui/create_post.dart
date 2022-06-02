import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/async_states.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/components/list_of_users.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/stores/create_posts_stores.dart';
import 'package:ootopia_app/data/models/post/post_create_model.dart';
import 'package:ootopia_app/data/models/post/post_gallery_create_model.dart';
import 'package:ootopia_app/screens/camera_screen/custom_gallery/components/media_view_widget.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/post_preview_screen/components/confirm_post_button_widget.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/multi_manager/flick_multi_manager.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class CreatePostPage extends StatefulWidget {
  final Map<String, dynamic> args;
  CreatePostPage(this.args);

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage>
    with SecureStoreMixin, WidgetsBindingObserver {
  FlickManager? flickManager;
  late VideoPlayerController videoPlayer;
  late FlickMultiManager flickMultiManager;
  // InterestsTagsRepositoryImpl _tagsRepository = InterestsTagsRepositoryImpl();

  double mirror = 0;
  late HomeStore homeStore;
  late WalletStore walletStore;

  final ScrollController scrollController = ScrollController();
  //bool _isLoading = true;
  bool _errorOnGetTags = false;
  bool _createdPost = false;
  bool _processingVideoInBackground = false;
  bool _processingVideoInBackgroundError = false;
  bool _readyToSendPost =
      false; //Será "true" quando o usuário tentar enviar um vídeo que está sendo processado em background com o ffmpeg

  String tagsErrorMessage = "";
  Image? image;
  Size? imageSize;
  String currenLocalization = '';
  //String conditional = "";
  //List filteredList = [];
  //SecureStoreMixin secureStoreMixin = SecureStoreMixin();
  final pageController = SmartPageController.getInstance();
  bool sendingPost = false;
  StoreCreatePosts storeCreatePosts = GetIt.I.get();
  PostCreate postData = PostCreate();
  PostGalleryCreateModel postGallery = PostGalleryCreateModel();

  // List<MultiSelectItem<InterestsTagsModel>> _items = [];

  // List<InterestsTagsModel> _selectedTags = [];

  // Future<void> _getTags() async {
  //   setState(() {
  //     _isLoading = true;
  //     _errorOnGetTags = false;
  //   });

  //   currenLocalization = Platform.localeName.substring(0, 2);

  //   this._tagsRepository.getTags(currenLocalization).then((tags) {
  //     setState(() {
  //       _isLoading = false;
  //       _items = tags
  //           .map((tag) => MultiSelectItem<InterestsTagsModel>(tag, tag.name))
  //           .toList();
  //     });
  //   }).onError((error, stackTrace) {
  //     setState(() {
  //       _isLoading = false;
  //       _errorOnGetTags = true;
  //     });
  //   });
  // }

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

  // void sendPost() async {
  //   if (_processingVideoInBackgroundError) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(AppLocalizations.of(context)!
  //             .thereAasAProblemLoadingTheVideoPleaseTryToUploadTheVideoAgain),
  //       ),
  //     );
  //     return;
  //   }

  //   if (_selectedTags.length < 1) {
  //     setState(() {
  //       tagsErrorMessage =
  //           AppLocalizations.of(context)!.pleaseSelectAtLeast1Tag;
  //     });
  //     return;
  //   }

  //   if (sendingPost) {
  //     return;
  //   }

  //   if (_processingVideoInBackground) {
  //     _readyToSendPost = true;
  //     postPreviewStore.uploadIsLoading = true;
  //   }

  //   postGallery.tagsIds = _selectedTags.map((tag) => tag.id).toList();
  //   String mediaType = widget.args["type"] == "image" ? "image" : "video";
  //   var newTextComment = _descriptionInputController.text;
  //   List<String>? idsUsersTagged = [];

  //   if (postPreviewStore.listTaggedUsers != null) {
  //     int newStartIndex = 0;
  //     int endNameUser = 0;
  //     postPreviewStore.listTaggedUsers?.forEach((user) {
  //       idsUsersTagged.add(user.id);
  //       String newString = "@[${user.id}]";
  //       var startname =
  //           newTextComment.indexOf('‌@${user.fullname}‌', endNameUser);
  //       newTextComment = newTextComment.replaceRange(
  //         startname + newStartIndex,
  //         user.fullname.length + startname + newStartIndex + 3,
  //         newString,
  //       );
  //       endNameUser = user.id.length + startname + 3;
  //       newStartIndex =
  //           newStartIndex + newString.length - (endNameUser - startname);
  //     });
  //   }

  //   postGallery.taggedUsersId = idsUsersTagged;
  //   postGallery.description = newTextComment;
  //   sendingPost = true;

  //   try {
  //     List<Map> fileList = widget.args["fileList"] != null
  //         ? widget.args["fileList"]
  //         : [
  //             {
  //               "mediaFile": File(widget.args["filePath"]),
  //               "mediaType": widget.args["type"]
  //             }
  //           ];

  //     await this.postPreviewStore.sendMedia(fileList, postGallery);
  //     sendingPost = false;

  //     await this.walletStore.getWallet();

  //     if (this.postPreviewStore.successOnUpload) {
  //       Navigator.of(context).pushNamedAndRemoveUntil(
  //         PageRoute.Page.homeScreen.route,
  //         ModalRoute.withName('/'),
  //         arguments: {
  //           "createdPost": true,
  //           "oozToReward": this.postPreviewStore.oozToReward
  //         },
  //       );
  //     } else if (this.postPreviewStore.errorOnUpload) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(AppLocalizations.of(context)!
  //               .thereWasAProblemUploadingTheVideoPleaseTryToUploadTheVideoAgain
  //               .replaceAll("video", mediaType)),
  //         ),
  //       );
  //     }

  //     postPreviewStore.clearhashtags();
  //   } catch (e) {
  //     sendingPost = false;
  //   }
  // }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      storeCreatePosts.getLocation(context);
    });

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
              _readyToSendPost = false;
              // sendPost();
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
            _readyToSendPost = false;
          });
        }
      });
    }

    if (widget.args["type"] == "image") {
      _getSizeImage();
    }
  }

  @override
  void dispose() {
    storeCreatePosts.cancelTimer();
    if (widget.args["type"] == "video") {
      flickManager!.dispose();
      flickMultiManager.remove(flickManager!);
      videoPlayer.dispose();
    }
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.restoreSystemUIOverlays();
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
    //postPreviewStore = Provider.of<PostPreviewScreenStore>(context);
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
                onTap: () {
                  storeCreatePosts.openSelectedUser = false;
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: body()),
            if (storeCreatePosts.openSelectedUser)
              ListOfUsers(
                createPosts: storeCreatePosts,
                inputController: storeCreatePosts.descriptionInputController,
                scrollController: scrollController,
                addUserInText: storeCreatePosts.addUserInText,
              ),
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
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      );

  Widget body() {
    return Observer(
      builder: (context) {
        if (storeCreatePosts.viewState == AsyncStates.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(GlobalConstants.of(context).spacingSmall),
            child: Column(
              children: [
                widget.args["fileList"] == null
                    ? MediaViewWidget(
                        mediaFilePath: widget.args["filePath"],
                        mediaType: widget.args["type"],
                        shouldCustomFlickManager: true,
                        mediaSize: widget.args["type"] == "video"
                            ? null
                            : this.imageSize!,
                      )
                    : buildListOfMedias(),
                SizedBox(height: 50),

                Visibility(
                  visible: storeCreatePosts.geolocationErrorMessage.isNotEmpty,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: GlobalConstants.of(context).spacingNormal,
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              GlobalConstants.of(context).spacingNormal),
                      width: double.infinity,
                      child: ElevatedButton(
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
                          storeCreatePosts.getLocation(context);
                        },
                        style: ElevatedButton.styleFrom(
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
                ),
                Visibility(
                  visible: storeCreatePosts.geolocationErrorMessage.isNotEmpty,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: GlobalConstants.of(context).spacingNormal,
                      bottom: GlobalConstants.of(context).spacingSmall,
                      left: GlobalConstants.of(context).screenHorizontalSpace,
                      right: GlobalConstants.of(context).screenHorizontalSpace,
                    ),
                    child: Text(
                      storeCreatePosts.geolocationErrorMessage +
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
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: GlobalConstants.of(context).spacingNormal),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, PageRoute.Page.interstingTags.route);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom:
                                  GlobalConstants.of(context).spacingNormal),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.search,
                                      color: LightColors.blue,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.searchForAtag,
                                    style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      color: LightColors.grey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              // Text(
                              //     postPreviewStore.selectedTags.length ==
                              //             0
                              //         ? ""
                              //         : "${postPreviewStore.selectedTags.length} ${postPreviewStore.selectedTags.length > 1 ? AppLocalizations.of(context)!.selecteds : AppLocalizations.of(context)!.selected2}",
                              //     style: GoogleFonts.roboto(
                              //         fontSize: 12,
                              //         color: Colors.grey,
                              //         fontWeight: FontWeight.w400)),
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
                            // ...postPreviewStore.selectedTags
                            //     .map((item) => GestureDetector(
                            //           onTap: () {
                            //             postPreviewStore.selectedTags
                            //                 .remove(item);
                            //           },
                            //           child: Container(
                            //             height: 38,
                            //             margin: EdgeInsets.only(
                            //                 bottom: GlobalConstants.of(
                            //                         context)
                            //                     .spacingSmall,
                            //                 left: 2),
                            //             padding: EdgeInsets.symmetric(
                            //                 horizontal:
                            //                     GlobalConstants.of(
                            //                             context)
                            //                         .intermediateSpacing,
                            //                 vertical: GlobalConstants.of(
                            //                         context)
                            //                     .smallIntermediateSpacing),
                            //             decoration: BoxDecoration(
                            //                 borderRadius:
                            //                     BorderRadius.circular(35),
                            //                 color: LightColors.darkBlue),
                            //             child: Row(
                            //               mainAxisSize: MainAxisSize.min,
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment
                            //                       .spaceBetween,
                            //               children: [
                            //                 Padding(
                            //                   padding:
                            //                       const EdgeInsets.only(
                            //                           right: 12),
                            //                   child: Text(item.name,
                            //                       style: GoogleFonts.roboto(
                            //                           color: Colors.white,
                            //                           fontWeight:
                            //                               FontWeight.bold,
                            //                           fontSize: Theme.of(
                            //                                   context)
                            //                               .textTheme
                            //                               .headline5!
                            //                               .fontSize)),
                            //                 ),
                            //                 Icon(
                            //                   Icons.close,
                            //                   color: Colors.white,
                            //                   size: 16,
                            //                 )
                            //               ],
                            //             ),
                            //           ),
                            //         ))
                            //     .toList()
                          ],
                        ),
                      ),
                    ],
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
                    controller: storeCreatePosts.descriptionInputController,
                    onChanged: storeCreatePosts.onChanged,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      hintText: AppLocalizations.of(context)!.writeADescription,
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
                Container(
                  margin: EdgeInsets.only(top: 28),
                  child: ConfirmButtonWidget(
                      content: Text(
                        AppLocalizations.of(context)!.publish,
                        style: GoogleFonts.roboto(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(new FocusNode());

                        // sendPost();
                      }),
                )
                // Visibility(
                //   visible: _errorOnGetTags && !_isLoading,
                //   child: Container(
                //     width: double.infinity,
                //     child: TryAgain(
                //       _getTags,
                //       showOnlyButton: true,
                //       buttonText: AppLocalizations.of(context)!
                //           .errorLoadingTagsTryAgain,
                //       buttonBackgroundColor: Colors.white,
                //       messageTextColor: Colors.white,
                //       buttonTextColor: Colors.black,
                //     ),
                //   ),
                // ),
                // Visibility(
                //   visible: tagsErrorMessage.isNotEmpty,
                //   child: Padding(
                //     padding: EdgeInsets.only(
                //       top: 8,
                //     ),
                //     child: Container(
                //       alignment: Alignment.center,
                //       width: double.infinity,
                //       child: Text(
                //         tagsErrorMessage,
                //         textAlign: TextAlign.center,
                //         style: GoogleFonts.roboto(
                //           fontSize: 12,
                //           color: Color(0xff8E1816),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // Visibility(
                //   visible: _isLoading,
                //   child: Center(
                //     child: SizedBox(
                //       width: 32,
                //       height: 32,
                //       child: CircularProgressIndicator(),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: GlobalConstants.of(context).spacingNormal,
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildListOfMedias() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...widget.args["fileList"].map(buildMediaRow).toList(),
        ],
      ),
    );
  }

  void changeMediaFile(File newImage, var oldImage) {
    int index = widget.args["fileList"]
        .indexWhere((element) => element["mediaId"] == oldImage["mediaId"]);

    widget.args["fileList"][index]["mediaFile"] = newImage;
  }

  buildMediaRow(dynamic file) {
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      height: MediaQuery.of(context).size.width - 60,
      child: MediaViewWidget(
        mediaFilePath: file["mediaFile"].path,
        mediaType: file["mediaType"],
        mediaSize: file["mediaSize"],
        shouldCustomFlickManager: true,
        showCropWidget: true,
        onChanged: (value) {
          changeMediaFile(value, file);
        },
      ),
    );
  }
}
