import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ToastMessageWidget extends StatelessWidget {
  final String toastText;
  const ToastMessageWidget({Key? key, required this.toastText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: GlobalConstants.of(context).screenHorizontalSpace + 5,
      child: Container(
        width: MediaQuery.of(context).size.width - 55,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: LightColors.cyan,
        ),
        child: Row(
          children: [
            SizedBox(width: 15),
            SvgPicture.asset(
              'assets/icons/Icon-feather-check.svg',
              height: 18,
              width: 18,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              toastText,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
