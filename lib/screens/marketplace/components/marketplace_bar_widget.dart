import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/theme/light/colors.dart';

class MarketplaceBarWidget extends StatelessWidget {
  const MarketplaceBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 60,
      padding: EdgeInsets.symmetric(
        horizontal: GlobalConstants.of(context).intermediateSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/icons/marketplace_black_icon.png",
              ),
              const SizedBox(width: 4),
              Text(
                'Marketplace',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.createAnOffer,
                style: TextStyle(
                  color: LightColors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                color: LightColors.blue,
                size: 12,
              )
            ],
          )
        ],
      ),
    );
  }
}
