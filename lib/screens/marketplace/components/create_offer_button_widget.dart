import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ootopia_app/theme/light/colors.dart';

class CreateOfferButtonWidget extends StatelessWidget {
  final Function onTap;
  const CreateOfferButtonWidget({Key? key, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final sizeConstraints = widthScreen >= 760
                ? (constraints.maxWidth / 4) - 24
                : (constraints.maxWidth / 2) - 24;
            return Column(
              children: [
                SizedBox(height: 44.6),
                DottedBorder(
                  strokeCap: StrokeCap.square,
                  dashPattern: [10, 10],
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  padding: EdgeInsets.all(0),
                  color: LightColors.grey,
                  child: Container(
                    width: sizeConstraints,
                    height: sizeConstraints,
                    decoration: BoxDecoration(
                      color: LightColors.grey.withOpacity(.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/thin_add_icon.svg',
                            height: 48,
                            width: 48,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            AppLocalizations.of(context)!.createYourOffer,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: LightColors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
