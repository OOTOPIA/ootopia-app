import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/screens/components/select_language/language_select_controller.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/theme/light/colors.dart';

class LanguageSelectWidget extends StatefulWidget {
  final LanguageSelectController languageSelectController;
  final List<String>? languages;
  LanguageSelectWidget({Key? key, this.languages, required this.languageSelectController}) : super(key: key);

  @override
  State<LanguageSelectWidget> createState() => _LanguageSelectWidgetState();
}

class _LanguageSelectWidgetState extends State<LanguageSelectWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.languages != null) {
      widget.languageSelectController.languages = widget.languages!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.accessOthersLanguages,
          style: TextStyle(
            color: Color(0xff707070),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Text(
          AppLocalizations.of(context)!.selecLanguages,
          style: TextStyle(
            color: Color(0xff707070),
            fontSize: 12,
          ),
        ),
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            languageComponent(
              language: AppLocalizations.of(context)!.portuguese,
              value: 'pt-BR',
            ),
            languageComponent(
                language: AppLocalizations.of(context)!.english, value: 'en'),
            languageComponent(
                language: AppLocalizations.of(context)!.french, value: 'fr'),
          ],
        ),
      ],
    );
  }

  Widget languageComponent({String? language, String? value}) {
    return GestureDetector(
      onTap: () {
        if (widget.languageSelectController.hasLanguage(value!))
          widget.languageSelectController.removeItem(value);
        else
          widget.languageSelectController.addItem(value);
        setState(() {});
      },
      child: Container(
        height: 38,
        margin: EdgeInsets.only(
          bottom: GlobalConstants.of(context).spacingSmall,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: GlobalConstants.of(context).intermediateSpacing,
        ),
        decoration: BoxDecoration(
          color: widget.languageSelectController.hasLanguage(value!)
              ? LightColors.darkBlue
              : Colors.white,
          border: Border.all(
            color: Color(0xFF707070),
          ),
          borderRadius: BorderRadius.circular(35),
        ),
        child: Center(
          child: Text(
            language!,
            style: GoogleFonts.roboto(
                color: widget.languageSelectController.hasLanguage(value)
                    ? Colors.white
                    : Colors.black.withOpacity(0.6),
                fontWeight: FontWeight.w600,
                fontSize: Theme.of(context).textTheme.headline5!.fontSize),
          ),
        ),
      ),
    );
  }
}
