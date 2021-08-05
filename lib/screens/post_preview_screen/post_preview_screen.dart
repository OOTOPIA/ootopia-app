import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/bloc/post/post_bloc.dart';
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'package:ootopia_app/data/models/post/post_create_model.dart';
import 'package:ootopia_app/data/repositories/interests_tags_repository.dart';
import 'package:ootopia_app/screens/components/try_again.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/multi_manager/flick_multi_manager.dart';
import 'package:ootopia_app/shared/geolocation.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:provider/provider.dart';
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

class _PostPreviewPageState extends State<PostPreviewPage> {
  late FlickManager flickManager;
  late VideoPlayerController videoPlayer;
  late FlickMultiManager flickMultiManager;
  late PostBloc postBloc;
  InterestsTagsRepositoryImpl _tagsRepository = InterestsTagsRepositoryImpl();
  final TextEditingController _descriptionInputController =
      TextEditingController();
  final TextEditingController _geolocationInputController =
      TextEditingController();
  double mirror = 0;
  late HomeStore homeStore;

  bool _isLoading = true;
  bool _isLoadingUpload = false;
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

  PostCreate postData = PostCreate();

  List<MultiSelectItem<InterestsTags>> _items = [];

  List<InterestsTags> _selectedTags = [];

  Future<void> _getTags() async {
    setState(() {
      _isLoading = true;
      _errorOnGetTags = false;
    });
    this._tagsRepository.getTags().then((tags) {
      setState(() {
        _isLoading = false;
        _items = tags
            .map((tag) => MultiSelectItem<InterestsTags>(tag, tag.name))
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
          print("Placemark: ${placemark.toJson()}");
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
    if (flickManager.flickControlManager!.isFullscreen) {
      flickManager.flickControlManager!.toggleFullscreen();
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
                  onPressed: () => Navigator.of(context).pop(true),
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

  void _sendPost() {
    if (_processingVideoInBackgroundError) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .thereAasAProblemLoadingTheVideoPleaseTryToUploadTheVideoAgain),
        ),
      );
      return;
    }

    if (_processingVideoInBackground) {
      _readyToSendPost = true;
      setState(() {
        _isLoadingUpload = true;
      });
    }

    if (_selectedTags.length < 1) {
      setState(() {
        tagsErrorMessage =
            AppLocalizations.of(context)!.pleaseSelectAtLeast1Tag;
      });
      return;
    }

    postData.tagsIds = _selectedTags.map((tag) => tag.id).toList();
    postData.type = widget.args["type"] == "image" ? "image" : "video";
    postData.description = _descriptionInputController.text;

    if (postData.type == "video") {
      postData.durationInSecs = (flickManager.flickVideoManager!
                  .videoPlayerValue!.duration.inMilliseconds %
              60000) /
          1000;
    }

    postBloc.add(
      CreatePostEvent(
        post: postData,
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _getLocation(context);
    });
    super.initState();

    postBloc = BlocProvider.of<PostBloc>(context);

    flickMultiManager = FlickMultiManager();
    videoPlayer = VideoPlayerController.file(File(widget.args["filePath"]))
      ..setLooping(true);

    postData.filePath = widget.args["filePath"];

    flickManager = FlickManager(
      videoPlayerController: videoPlayer,
    );

    flickMultiManager.init(flickManager);

    flickManager.flickControlManager!.mute();

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
              _isLoadingUpload = false;
              _readyToSendPost = false;
              _sendPost();
            }
          });
        }
      }).catchError((onError) {
        _processingVideoInBackground = false;
        _processingVideoInBackgroundError = true;
        if (_readyToSendPost && this.mounted) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!
                  .thereWasAProblemUploadingTheVideoPleaseTryToUploadTheVideoAgain),
            ),
          );
          setState(() {
            _isLoadingUpload = false;
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
  void dispose() {
    flickMultiManager.remove(flickManager);
    flickManager.dispose();
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
    homeStore = Provider.of<HomeStore>(context);
    return new WillPopScope(
      onWillPop: () => _onWillPop(true),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => _onWillPop(false),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
          titleSpacing: 0,
          title: Text(
            AppLocalizations.of(context)!.newPost,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => _sendPost(),
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: Color(0xff018F9C),
                    ),
                    SizedBox(
                      width: GlobalConstants.of(context).spacingSmall,
                    ),
                    Text(
                      "Publish",
                      style: TextStyle(
                        color: Color(0xff018F9C),
                      ),
                    ),
                    SizedBox(
                      width: GlobalConstants.of(context).spacingNormal,
                    ),
                  ],
                ))
          ],
        ),
        body: BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            if (state is ErrorCreatePostState) {
              _isLoading = false;
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
              _isLoadingUpload = false;
            } else if (state is LoadingCreatePostState) {
              _isLoadingUpload = true;
            } else if (state is SuccessCreatePostState) {
              _isLoadingUpload = false;
              _createdPost = true;
              Navigator.of(context).pushNamedAndRemoveUntil(
                PageRoute.Page.homeScreen.route,
                ModalRoute.withName('/'),
                arguments: {"createdPost": true},
              );
            }
          },
          child: _blocBuilder(),
        ),
      ),
    );
  }

  _blocBuilder() {
    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
      return LoadingOverlay(
        isLoading: _isLoadingUpload,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(GlobalConstants.of(context).spacingSmall),
            child: Column(
              children: [
                Container(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: widget.args["type"] == "video"
                          ? MediaQuery.of(context).size.height * .6
                          : MediaQuery.of(context).size.height * .5,
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
                                      flickManager: flickManager,
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
                                            flickManager
                                                    .flickControlManager!.isMute
                                                ? Icons.volume_off
                                                : Icons.volume_up,
                                            size: 20),
                                        onPressed: () => {
                                          setState(() {
                                            flickMultiManager.toggleMute();
                                          }),
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
                    controller: _descriptionInputController,
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
                    onChanged: (String val) {},
                  ),
                ),
                SizedBox(
                  height: GlobalConstants.of(context).screenHorizontalSpace,
                ),
                Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(
                      horizontal: GlobalConstants.of(context).spacingNormal),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(
                      color: Color(0xff707070),
                      width: .25,
                    ),
                  ),
                  child: TextFormField(
                    style: TextStyle(
                      color: Color(0xff003694),
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    enabled: false,
                    textAlign: TextAlign.left,
                    controller: _geolocationInputController,
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                        left: GlobalConstants.of(context).spacingNormal,
                        top: GlobalConstants.of(context).spacingNormal,
                        bottom: GlobalConstants.of(context).spacingSmall,
                      ),
                      hintText: geolocationMessage,
                      hintStyle: Theme.of(context).textTheme.subtitle1,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      suffixIcon: Icon(Icons.public),
                    ),
                  ),
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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: FlatButton(
                        height: 57,
                        child: Padding(
                          padding: EdgeInsets.all(
                            GlobalConstants.of(context).spacingNormal,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.getCurrentLocation,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
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
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(
                        color: Color(0xff707070),
                        width: .25,
                      ),
                    ),
                    margin: EdgeInsets.symmetric(
                        horizontal: GlobalConstants.of(context).spacingNormal),
                    child: MultiSelectDialogField<InterestsTags?>(
                      listType: MultiSelectListType.CHIP,
                      selectedColor: Color(0xff03145C),
                      selectedItemsTextStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                      searchable: true,
                      checkColor: Colors.blueAccent,
                      searchTextStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      unselectedColor: Colors.black.withOpacity(.05),
                      barrierColor: Colors.black.withOpacity(.5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(
                          color: Colors.transparent,
                          width: 0,
                        ),
                      ),
                      buttonIcon: Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.black54,
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.selectAtLeast1Tag,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      buttonText: Text(
                        AppLocalizations.of(context)!.selectTags,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      confirmText: Text(
                        AppLocalizations.of(context)!.confirm,
                        style: TextStyle(
                          color: Color(0xff018F9C),
                        ),
                      ),
                      cancelText: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          color: Color(0xff018F9C),
                        ),
                      ),
                      itemsTextStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                      items: _items,
                      onConfirm: (values) {
                        _selectedTags = [];
                        setState(() {
                          values.forEach((v) {
                            _selectedTags.add(v!);
                          });
                          if (_selectedTags.length >= 1) {
                            tagsErrorMessage = "";
                          }
                        });
                      },
                      chipDisplay: MultiSelectChipDisplay(
                        chipColor: Color(0xff03145C),
                        textStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        onTap: (value) {
                          setState(() {
                            _selectedTags.remove(value);
                          });
                        },
                      ),
                    ),
                  ),
                ),
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
                      top: GlobalConstants.of(context).spacingNormal,
                      bottom: GlobalConstants.of(context).spacingSmall,
                    ),
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        tagsErrorMessage,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.redAccent,
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
        ),
      );
    });
  }
}
