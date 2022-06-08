import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/components/bottom_open_interesting_tags.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/components/confirm_post_button_widget.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/components/error_get_geolocation.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/components/hashtag_component.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/components/list_of_midias.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/components/list_of_users.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/components/show_dialog.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/components/text_field_component.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/stores/create_posts_stores.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/stores/interesting_tags_store.dart';
import 'package:ootopia_app/screens/camera_screen/custom_gallery/components/media_view_widget.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class CreatePostPage extends StatefulWidget {
  final Map<String, dynamic> args;
  CreatePostPage(this.args);

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  Image? image;
  Size? imageSize;

  final pageController = SmartPageController.getInstance();
  StoreCreatePosts storeCreatePosts = GetIt.I.get();
  InterestingTagsStore _interestingTagsStore = GetIt.I.get();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      storeCreatePosts.getLocation(context);
    });

    if (widget.args['type'] == 'image') {
      _getSizeImage();
    }
  }

  @override
  void dispose() {
    storeCreatePosts.cancelTimer();
    storeCreatePosts.clearVariable();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.restoreSystemUIOverlays();
    super.dispose();
  }

  void _getSizeImage() {
    this.image = Image.file(
      File(widget.args['filePath']),
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

  PreferredSizeWidget get appbar => DefaultAppBar(
        components: [
          AppBarComponents.back,
          AppBarComponents.close,
        ],
        onTapLeading: () {
          showDialogDiscardChanges(context);
        },
        onTapAction: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: Observer(builder: (context) {
        if (storeCreatePosts.loading) {
          return Center(child: CircularProgressIndicator());
        }
        return Stack(
          fit: StackFit.expand,
          children: [
            BackgroundButterflyTop(positioned: -59),
            Visibility(
                visible: MediaQuery.of(context).viewInsets.bottom == 0,
                child: BackgroundButterflyBottom()),
            GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  storeCreatePosts.openSelectedUser = false;
                },
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(
                        GlobalConstants.of(context).spacingSmall),
                    child: Column(
                      children: [
                        widget.args['fileList'] == null
                            ? MediaViewWidget(
                                mediaFilePath: widget.args['filePath'],
                                mediaType: widget.args['type'],
                                shouldCustomFlickManager: true,
                                mediaSize: widget.args['type'] == 'video'
                                    ? null
                                    : this.imageSize!,
                              )
                            : ListOfMidias(args: widget.args),
                        if (storeCreatePosts.geolocationErrorMessage.isNotEmpty)
                          ErrorGetGeolocation(),
                        if (_interestingTagsStore.selectedTags.isNotEmpty)
                          Container(
                            height: 50,
                            padding: EdgeInsets.only(bottom: 8),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount:
                                  _interestingTagsStore.selectedTags.length,
                              itemBuilder: (BuildContext context, int index) {
                                var tagSelected =
                                    _interestingTagsStore.selectedTags[index];
                                return hashtagComponent(
                                  tagSelected: tagSelected,
                                  deleteHashTag: () {
                                    _interestingTagsStore.selectedTags
                                        .remove(tagSelected);
                                  },
                                );
                              },
                            ),
                          ),
                        ButtonOpenInterestingTags(),
                        TextFormFieldCreatePost(),
                        SizedBox(
                            height: GlobalConstants.of(context)
                                .screenHorizontalSpace),
                        Container(
                          margin: EdgeInsets.only(top: 28),
                          child: ConfirmButtonWidget(
                              content: Text(
                                AppLocalizations.of(context)!.publish,
                                style: GoogleFonts.roboto(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                _interestingTagsStore.selectedTags.clear();
                                _interestingTagsStore.selectedTags
                                    .forEach((element) {
                                  storeCreatePosts.tagsid.add(element.id);
                                });
                                List<Map> fileList =
                                    widget.args['fileList'] != null
                                        ? widget.args['fileList']
                                        : [
                                            {
                                              'mediaFile':
                                                  File(widget.args['filePath']),
                                              'mediaType': widget.args['type']
                                            }
                                          ];
                                await storeCreatePosts.sendMedia(fileList);
                                if (storeCreatePosts.error.isNotEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(storeCreatePosts.error),
                                  ));
                                } else {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    PageRoute.Page.homeScreen.route,
                                    ModalRoute.withName('/'),
                                    arguments: {
                                      'createdPost': true,
                                      "oozToReward": 0
                                    },
                                  );
                                }
                              }),
                        )
                      ],
                    ),
                  ),
                )),
            if (storeCreatePosts.openSelectedUser) ListOfUsers()
          ],
        );
      }),
    );
  }
}
