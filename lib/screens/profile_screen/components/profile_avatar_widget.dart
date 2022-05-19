import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';

import 'package:ootopia_app/screens/profile_screen/components/avatar_photo_widget.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_screen_store.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class ProfileAvatarWidget extends StatelessWidget {
  final ProfileScreenStore? profileScreenStore;
  final AuthStore? authStore;
  const ProfileAvatarWidget({
    Key? key,
    this.profileScreenStore,
    this.authStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AvatarPhotoWidget(
      photoUrl: profileScreenStore?.profile!.photoUrl,
      sizePhotoUrl: 114,
      isBadges: profileScreenStore == null
          ? false
          : profileScreenStore!.profile!.badges!.length > 0,
      onTap: () {
        showModalBottomSheet(
          context: context,
          barrierColor: Colors.black.withAlpha(1),
          backgroundColor: Colors.black.withAlpha(1),
          builder: (BuildContext context) {
            return SnackBarWidget(
              menu: AppLocalizations.of(context)!.changeMakerPro,
              text: AppLocalizations.of(context)!
                  .theChangeMakerProBadgeIsAwardedToIndividualsAndOrganizationsThatAreLeadingConsistentWorkToHelpRegeneratePlanetEarth,
              buttons: [
                ButtonSnackBar(
                  text: AppLocalizations.of(context)!.learnMore,
                  onTapAbout: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      PageRoute.Page.homeScreen.route,
                      (Route<dynamic> route) => false,
                      arguments: {
                        "returnToPageWithArgs": {
                          'currentPageName': "learning_tracks"
                        }
                      },
                    );
                  },
                )
              ],
              marginBottom: true,
              contact: {
                "text": AppLocalizations.of(context)!.areYouAChangeMakerProToo,
                "textLink": AppLocalizations.of(context)!.getInContact,
              },
            );
          },
        );
      },
    );
  }
}
