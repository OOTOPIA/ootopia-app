import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/clean_arch/core/constants/colors.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtonOpenInterestingTags extends StatelessWidget {
  const ButtonOpenInterestingTags({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: GlobalConstants.of(context).spacingNormal),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, PageRoute.Page.interstingTags.route);
            },
            child: Container(
              margin: EdgeInsets.only(
                  bottom: GlobalConstants.of(context).spacingNormal),
              height: 57,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: LightColors.grey,
                  width: 0.25,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.search,
                          color: LightColors.blue,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.searchForAtag,
                        style: GoogleFonts.roboto(
                          fontSize: 15,
                          color: LightColors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
