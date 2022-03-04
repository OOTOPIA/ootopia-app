import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/screens/components/share_link.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PopupMenuMarkeplace extends StatefulWidget {
  final ProductModel productModel;

  PopupMenuMarkeplace({
    required this.productModel,
  });
  @override
  _PopupMenuMarkeplaceState createState() => _PopupMenuMarkeplaceState();
}

class _PopupMenuMarkeplaceState extends State<PopupMenuMarkeplace> {
  @override
  void initState() {
    super.initState();
  }

  copyLink(Type type, String id, BuildContext context) {
    try {
      String link;
      link = '${dotenv.env['LINK_SHARING_URL_API']!}market-place/shared/$id';

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

      text = AppLocalizations.of(context)!.nowYouCanShareThisOffer;

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

  _selectedOption(String optionSelected) {
    if (optionSelected == 'shared') {
      copyLink(Type.offer, widget.productModel.id, context);
      modalSharedCopyLink(Type.offer, context);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Icon(Icons.more_vert),
      itemBuilder: (_) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          child: Column(
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Padding(
                    child: SvgPicture.asset(
                      'assets/icons/link.svg',
                      color: Color(0xff707070),
                      width: 20,
                      height: 20,
                    ),
                    padding: EdgeInsets.only(right: 4),
                  ),
                  Text(
                    AppLocalizations.of(context)!.copyLink,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          value: 'shared',
        ),
      ],
      onSelected: (String value) => _selectedOption(value),
    );
  }
}
