import 'package:flutter/material.dart';
import 'package:ootopia_app/shared/global-constants.dart';

class NewPostUploadedMessageBox extends StatelessWidget {
  NewPostUploadedMessageBox({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(GlobalConstants.of(context).spacingSmall),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xff03DAC5),
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
                    text,
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
