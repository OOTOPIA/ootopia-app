import 'dart:io';

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
import 'package:ootopia_app/screens/timeline/components/feed_player/multi_manager/flick_multi_manager.dart';
import 'package:ootopia_app/shared/geolocation.dart';
import 'package:ootopia_app/shared/global-constants.dart';
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
          geolocationMessage = AppLocalizations.of(context)!.failedToGetCurrentLocation;
          geolocationErrorMessage = AppLocalizations.of(context)!.weCouldntGetYourLocation2;
        }
      });
    }).onError((error, stackTrace) {
      setState(() {
        geolocationMessage = AppLocalizations.of(context)!.failedToGetCurrentLocation;
        geolocationErrorMessage = error.toString();
      });
    });
  }

  Future<bool> _onWillPop() async {
    if (_createdPost) {
      return true;
    }
    if (flickManager.flickControlManager!.isFullscreen) {
      flickManager.flickControlManager!.toggleFullscreen();
      return false;
    }
    return (await showDialog(
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
                        AppLocalizations.of(context)!.doYouWantToDiscardTheChanges,
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
        )) ??
        false;
  }

  void _sendPost() {
    if (_processingVideoInBackgroundError) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context)!.thereAasAProblemLoadingTheVideoPleaseTryToUploadTheVideoAgain),
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
        tagsErrorMessage = AppLocalizations.of(context)!.pleaseSelectAtLeast1Tag;
      });
      return;
    }

    postData.tagsIds = _selectedTags.map((tag) => tag.id).toList();
    postData.type = "video";
    postData.description = _descriptionInputController.text;

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
      autoPlay: false,
    );

    flickMultiManager.init(flickManager);

    flickManager.flickControlManager!.mute();

    if (widget.args["mirroredVideo"] == "true") {
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
              content: Text(
                  AppLocalizations.of(context)!.thereWasAProblemUploadingTheVideoPleaseTryToUploadTheVideoAgain),
            ),
          );
          setState(() {
            _isLoadingUpload = false;
            _readyToSendPost = false;
          });
        }
      });
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

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.newPost,
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffC0D9E8),
                  Color(0xffffffff),
                ],
              ),
            ),
          ),
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
              //go to next page
              _isLoadingUpload = false;
              _createdPost = true;
              Navigator.of(context).pushNamedAndRemoveUntil(
                PageRoute.Page.timelineScreen.route,
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
                        maxHeight: MediaQuery.of(context).size.height * .6),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Transform(
                            alignment: Alignment.center,
                            child: FlickVideoPlayer(
                              preferredDeviceOrientationFullscreen: [],
                              flickManager: flickManager,
                              flickVideoWithControls: FlickVideoWithControls(
                                controls: null,
                              ),
                            ),
                            transform: Matrix4.rotationY(mirror),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(
                                  GlobalConstants.of(context).spacingSmall),
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
                                      flickManager.flickControlManager!.isMute
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
                        ),
                      ],
                    ),
                  ),
                ),
                TextFormField(
                  controller: _descriptionInputController,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.writeADescription,
                    hintStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12, width: 1.5),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12, width: 1.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 1.5),
                    ),
                  ),
                  onChanged: (String val) {},
                ),
                SizedBox(
                  height: GlobalConstants.of(context).spacingNormal,
                ),
                Container(
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                    enabled: false,
                    textAlign: TextAlign.left,
                    controller: _geolocationInputController,
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                        left: GlobalConstants.of(context).spacingSmall,
                        right: GlobalConstants.of(context).spacingSmall,
                        top: GlobalConstants.of(context).spacingNormal,
                        bottom: GlobalConstants.of(context).spacingSmall,
                      ),
                      hintText: geolocationMessage,
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
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
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: FlatButton(
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
                            color: Colors.black12,
                            width: 1.5,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(50),
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
                          AppLocalizations.of(context)!.tryToRetrieveYourCurrentLocationClickingByGetLocationAgain,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: GlobalConstants.of(context).spacingNormal,
                ),
                Visibility(
                  visible: !_errorOnGetTags && !_isLoading,
                  child: MultiSelectDialogField<InterestsTags?>(
                    listType: MultiSelectListType.CHIP,
                    selectedColor: Colors.blue,
                    selectedItemsTextStyle: TextStyle(color: Colors.white),
                    searchable: true,
                    searchTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      border: Border.all(
                        color: Colors.black12,
                        width: 2,
                      ),
                    ),
                    buttonIcon: Icon(
                      Icons.add,
                      color: Colors.black54,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.selectAtLeast1Tag,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    buttonText: Text(
                      AppLocalizations.of(context)!.selectTags,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                      ),
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
                      onTap: (value) {
                        setState(() {
                          _selectedTags.remove(value);
                        });
                      },
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
                      buttonText: AppLocalizations.of(context)!.errorLoadingTagsTryAgain,
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
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xff73d778),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: FlatButton(
                    child: Padding(
                      padding: EdgeInsets.all(
                        GlobalConstants.of(context).spacingNormal,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.sendPost,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onPressed: () => _sendPost(),
                    splashColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color(0xff73d778),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

// class PlayerControls extends StatelessWidget {
//   const PlayerControls(
//       {Key key, this.flickMultiManager, this.flickManager, this.filePath})
//       : super(key: key);

//   final FlickMultiManager flickMultiManager;
//   final FlickManager flickManager;
//   final String filePath;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.transparent,
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           FlickAutoHideChild(
//             showIfVideoNotInitialized: false,
//             child: Align(
//               alignment: Alignment.topRight,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//                 decoration: BoxDecoration(
//                   color: Colors.black38,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: FlickLeftDuration(),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Container(),
//           ),
//           Align(
//             alignment: Alignment.bottomRight,
//             child: FlickAutoHideChild(
//               autoHide: false,
//               showIfVideoNotInitialized: false,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: <Widget>[
//                   Container(
//                     padding: EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                       color: Colors.black38,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: FlickSoundToggle(
//                       toggleMute: () => flickMultiManager.toggleMute(),
//                       color: Colors.white,
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.only(
//                       left: GlobalConstants.of(context).spacingNormal,
//                     ),
//                     child: FlickFullScreenToggle(
//                       toggleFullscreen: () {
//                         flickManager.flickControlManager.toggleFullscreen();
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
