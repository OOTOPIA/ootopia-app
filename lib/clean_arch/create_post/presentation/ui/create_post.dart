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
import 'package:ootopia_app/clean_arch/create_post/presentation/components/list_of_midias.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/components/list_of_users.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/components/show_dialog.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/components/text_field_component.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/stores/create_posts_stores.dart';
import 'package:ootopia_app/screens/camera_screen/custom_gallery/components/media_view_widget.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreatePostPage extends StatefulWidget {
  final Map<String, dynamic> args;
  CreatePostPage(this.args);

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final ScrollController scrollController = ScrollController();

  Image? image;
  Size? imageSize;

  final pageController = SmartPageController.getInstance();
  StoreCreatePosts storeCreatePosts = GetIt.I.get();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      storeCreatePosts.getLocation(context);
    });

    if (widget.args["type"] == "image") {
      _getSizeImage();
    }
  }

  @override
  void dispose() {
    storeCreatePosts.cancelTimer();
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
    return Scaffold(
      appBar: appbar(),
      body: Stack(
        fit: StackFit.expand,
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
            Observer(builder: (context) {
              return ListOfUsers(
                createPosts: storeCreatePosts,
                inputController: storeCreatePosts.descriptionInputController,
                scrollController: scrollController,
                addUserInText: storeCreatePosts.addUserInText,
              );
            }),
        ],
      ),
    );
  }

  PreferredSizeWidget appbar() => DefaultAppBar(
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

  Widget body() {
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
                    mediaSize:
                        widget.args["type"] == "video" ? null : this.imageSize!,
                  )
                : ListOfMidias(args: widget.args),
            SizedBox(height: 50),
            if (storeCreatePosts.geolocationErrorMessage.isNotEmpty)
              ErrorGetGeolocation(storeCreatePosts: storeCreatePosts),
            SizedBox(
              height: GlobalConstants.of(context).screenHorizontalSpace,
            ),
            ButtonOpenInterestingTags(),
            TextFormFieldCreatePost(
              storeCreatePosts: storeCreatePosts,
            ),
            SizedBox(height: GlobalConstants.of(context).screenHorizontalSpace),
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
          ],
        ),
      ),
    );
  }
}
