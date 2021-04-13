import 'package:flutter/material.dart';

class DialogConfirm extends StatelessWidget {
  final String textAlert;
  final Function callbackConfirmAlertDialog;

  DialogConfirm({
    this.textAlert,
    this.callbackConfirmAlertDialog,
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
          child: Text('Confirmar'),
          onPressed: () {
            this.callbackConfirmAlertDialog();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Recusar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
