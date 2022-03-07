import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/screens/components/share_link.dart';

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
