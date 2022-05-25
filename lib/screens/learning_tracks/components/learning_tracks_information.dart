import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/screens/components/information_widget.dart';
import 'package:ootopia_app/theme/light/colors.dart';


class LearningTrackInformation extends StatelessWidget {
  final onTap;

  const LearningTrackInformation({Key? key,
    required this.onTap}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InformationWidget(
          icon: SvgPicture.asset(
            "assets/icons/compass.svg",
            width: 24,
            color: LightColors.blue,
          ),
          title: AppLocalizations.of(context)!.learningTracks,
          text: AppLocalizations.of(context)!.learningTracksDescription,
          onTap: onTap,
        ),
        SizedBox(
          height: 8,
        ),
        Divider(
          color: Colors.grey,
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}


