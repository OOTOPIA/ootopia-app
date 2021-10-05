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
    return InkWell(
      onTap: () => onTap(),
      child: Column(
        children: [
          SizedBox(height: 42),
          DottedBorder(
            strokeCap: StrokeCap.square,
            dashPattern: [10, 10],
            borderType: BorderType.RRect,
            radius: Radius.circular(12),
            child: Container(
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
            ),
          ),
        ],
      ),
    );
  }
}
