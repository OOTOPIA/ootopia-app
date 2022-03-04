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
        try {
          copyLink(widget.type, widget.id, context);
          modalSharedCopyLink(widget.type, context);
        } catch (e) {
          print("ERROR AO COPIAR ${e.toString()}");
        }
      },
    );
  }
}

copyLink(Type type, String id, BuildContext context) {
  try {
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
  } catch (e) {
    print(
        "OQUE ACONTECEU AO COPIAR ESSE LINK  $type ${dotenv.env['LINK_SHARING_URL_API']!}posts/shared/$id \n /n ${e.toString()}");
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.black.withAlpha(1),
        backgroundColor: Colors.black.withAlpha(1),
        builder: (BuildContext context) {
          return SnackBarWidget(
            menu: AppLocalizations.of(context)!.linkCopied,
            automaticClosing: true,
            text:
                "OQUE ACONTECEU AO COPIAR ESSE LINK  $type ${dotenv.env['LINK_SHARING_URL_API']!}posts/shared/$id \n /n ${e.toString()}",
            marginBottom: true,
          );
        });
  }
}

modalSharedCopyLink(Type type, BuildContext context) {
  try {
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
  } catch (e) {
    print("MOSTRAR MODAL DE COPIADO $type ${e.toString()}");
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.black.withAlpha(1),
        backgroundColor: Colors.black.withAlpha(1),
        builder: (BuildContext context) {
          return SnackBarWidget(
            menu: AppLocalizations.of(context)!.linkCopied,
            automaticClosing: true,
            text: "MOSTRAR MODAL DE COPIADO $type ${e.toString()}",
            marginBottom: true,
          );
        });
  }
}
