import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class NewPostUploadedMessageBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(GlobalConstants.of(context).spacingSmall),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff73d778),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.all(
            GlobalConstants.of(context).spacingNormal,
          ),
          child: Row(
            children: [
              Icon(Icons.done, color: Colors.white),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: GlobalConstants.of(context).spacingSmall,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!
                        .yourVideoIsBeingProcessedWaitUntilProcessingIsComplete,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
