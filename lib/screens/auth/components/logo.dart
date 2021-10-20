import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ootopia_app/theme/light/colors.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 255,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 88),
            child: Image.asset(
              'assets/images/newlogo.png',
              height: 109,
              width: 56,
            ),
          ),
          SizedBox(height: 23),
          Container(
            width: 255,
            height: 47,
            child: Stack(
              children: [
                Positioned(
                  right: 7,
                  bottom: 10,
                  child: Container(
                    child: Image(
                      image: AssetImage("assets/images/butterfly.png"),
                      width: 41,
                      height: 37,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Text(
                    AppLocalizations.of(context)!.liveOotopiaNowMessage,
                    style: GoogleFonts.roboto(
                        color: LightColors.blue,
                        fontSize: 23,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
