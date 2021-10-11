import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        padding: const EdgeInsets.all(12.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                SizedBox(height: widthScreen <= 320 ? 36.6 : 44.6),
                DottedBorder(
                  strokeCap: StrokeCap.square,
                  dashPattern: [10, 10],
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  padding: EdgeInsets.all(0),
                  child: Container(
                    height: widthScreen >= 760
                        ? (constraints.maxWidth / 4) - 24
                        : (constraints.maxWidth / 2) - 24,
                    width: widthScreen >= 760
                        ? (constraints.maxWidth / 4) - 24
                        : (constraints.maxWidth / 2) - 24,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/thin_add_icon.svg',
                        ),
                        SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)!.createYourOffer,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: LightColors.grey,
                            fontSize: widthScreen <= 360 ? 14 : 18,
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: LightColors.grey.withOpacity(.05),
                      borderRadius: BorderRadius.circular(15),
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
