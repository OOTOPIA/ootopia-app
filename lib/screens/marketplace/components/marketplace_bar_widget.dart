import 'package:flutter/material.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
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
              Text(
                AppLocalizations.of(context)!.offers,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(PageRoute.Page.aboutEthicalMarketPlace.route);
            },
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.createAnOffer,
                  style: GoogleFonts.roboto(
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
            ),
          )
        ],
      ),
    );
  }
}
