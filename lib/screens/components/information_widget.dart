import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InformationWidget extends StatelessWidget {
  final Function onTap;
  final Widget icon;
  final String title;
  final String text;
  const InformationWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).iconTheme.color!.withOpacity(0.15),
      padding: EdgeInsets.symmetric(
        vertical: GlobalConstants.of(context).spacingNormal,
        horizontal: GlobalConstants.of(context).intermediateSpacing,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              icon,
              SizedBox(
                width: 8,
              ),
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: LightColors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  this.onTap();
                },
                child: Text(
                  AppLocalizations.of(context)!.learnMore,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: LightColors.blue,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
