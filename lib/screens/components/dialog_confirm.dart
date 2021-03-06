import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogConfirm extends StatelessWidget {
  final String textAlert;
  final Function callbackConfirmAlertDialog;

  DialogConfirm({
    required this.textAlert,
    required this.callbackConfirmAlertDialog,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              this.textAlert,
              style: Theme.of(context).textTheme.headline2,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.decline),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.confirm),
          onPressed: () {
            this.callbackConfirmAlertDialog();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
