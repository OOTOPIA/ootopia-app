import 'package:flutter/material.dart';
import 'package:ootopia_app/shared/global-constants.dart';

class ProfileBioWidget extends StatelessWidget {
  final String? bio;
  const ProfileBioWidget({Key? key, this.bio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: bio != null && bio != '',
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: GlobalConstants.of(context).screenHorizontalSpace),
            child: Text(
              bio != null ? bio! : "",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
