import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/global-constants.dart';

class LanguageUnderstoodWidget extends StatelessWidget {
  final List flags = [Colors.red, Colors.blue, Colors.green];
  LanguageUnderstoodWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: GlobalConstants.of(context).intermediateSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/globo1.svg',
                height: 17,
                width: 17,
              ),
              const SizedBox(width: 4),
              Text(
                AppLocalizations.of(context)!.languageUnderstood,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff707070),
                ),
              ),
            ],
          ),
          Row(
            children: [
              ...flags.map(languageFlag).toList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget languageFlag(dynamic flag) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1),
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: flag,
      ),
    );
  }
}
