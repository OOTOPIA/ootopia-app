import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ootopia_app/theme/light/colors.dart';

class CreateOfferButtonWidget extends StatelessWidget {
  const CreateOfferButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            size: 70,
          ),
          Text(
            AppLocalizations.of(context)!.createYourOffer,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: LightColors.grey,
            ),
          ),
        ],
      ),
      height: 171,
      width: 171,
      decoration: BoxDecoration(
        color: LightColors.grey.withOpacity(.05),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
