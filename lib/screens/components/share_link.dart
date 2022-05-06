import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Type { posts, offer, learning_track }

class ShareLink extends StatefulWidget {
  String id;
  Type type;

  ShareLink({
    Key? key,
    required this.id,
    required this.type,
  }) : super(key: key);

  @override
  ShareLinkState createState() => ShareLinkState();
}

class ShareLinkState extends State<ShareLink> {
  copyLink(Type type, String id, BuildContext context) {
    String link;
    switch (type) {
      case Type.posts:
        link = '${dotenv.env['LINK_SHARING_URL_API']!}posts/shared/$id';
        break;
      case Type.offer:
        link = '${dotenv.env['LINK_SHARING_URL_API']!}market-place/shared/$id';
        break;
      case Type.learning_track:
        link =
            '${dotenv.env['LINK_SHARING_URL_API']!}learning-tracks/shared/$id';
        break;
    }
    Clipboard.setData(ClipboardData(text: link));
  }

  modalSharedCopyLink(Type type, BuildContext context) {
    String text;
    switch (type) {
      case Type.posts:
        text = AppLocalizations.of(context)!.nowYouCanShareThisPost;
        break;
      case Type.offer:
        text = AppLocalizations.of(context)!.nowYouCanShareThisOffer;
        break;
      case Type.learning_track:
        text = AppLocalizations.of(context)!.nowYouCanShareThisLearningTracks;
        break;
    }

    showModalBottomSheet(
        context: context,
        barrierColor: Colors.black.withAlpha(1),
        backgroundColor: Colors.black.withAlpha(1),
        builder: (BuildContext context) {
          return SnackBarWidget(
            menu: AppLocalizations.of(context)!.linkCopied,
            automaticClosing: true,
            text: text,
            marginBottom: true,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: [
          Text(
            AppLocalizations.of(context)!.copyLink,
            style: TextStyle(
              color: LightColors.blue,
              fontSize: 14,
            ),
          ),
          SizedBox(
            width: 6,
          ),
          SvgPicture.asset(
            'assets/icons/link.svg',
            color: LightColors.blue,
          ),
        ],
      ),
      onTap: () {
        copyLink(widget.type, widget.id, context);
        modalSharedCopyLink(widget.type, context);
      },
    );
  }
}

copyLink(Type type, String id, BuildContext context) {
  String link;
  switch (type) {
    case Type.posts:
      link = '${dotenv.env['LINK_SHARING_URL_API']!}posts/shared/$id';
      break;
    case Type.offer:
      link = '${dotenv.env['LINK_SHARING_URL_API']!}market-place/shared/$id';
      break;
    case Type.learning_track:
      link = '${dotenv.env['LINK_SHARING_URL_API']!}learning-tracks/shared/$id';
      break;
  }

  Clipboard.setData(ClipboardData(text: link));
}

modalSharedCopyLink(Type type, BuildContext context) {
  String text;
  switch (type) {
    case Type.posts:
      text = AppLocalizations.of(context)!.nowYouCanShareThisPost;
      break;
    case Type.offer:
      text = AppLocalizations.of(context)!.nowYouCanShareThisOffer;
      break;
    case Type.learning_track:
      text = AppLocalizations.of(context)!.nowYouCanShareThisLearningTracks;
      break;
  }

  showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withAlpha(1),
      backgroundColor: Colors.black.withAlpha(1),
      builder: (BuildContext context) {
        return SnackBarWidget(
          menu: AppLocalizations.of(context)!.linkCopied,
          automaticClosing: true,
          text: text,
          marginBottom: true,
        );
      });
}
