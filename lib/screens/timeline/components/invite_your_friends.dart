import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/invitation_screen/invitation_screen.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class InviteYourFriends extends StatelessWidget {
  InviteYourFriends({Key? key}) : super(key: key);
  final SmartPageController controller = SmartPageController.getInstance();
  final AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  @override
  Widget build(BuildContext context) {
    final authStore = Provider.of<AuthStore>(context);
    return GestureDetector(
      onTap: () {
        if (authStore.currentUser != null) {
          trackingEvents.timelineInviteYourFriends();
          controller.insertPage(InvitationScreen());
        } else {
          Navigator.pushNamed(
            context,
            PageRoute.Page.loginScreen.route,
            arguments: {
              "returnToPageWithArgs": {
                "currentPageName": "home",
              },
              'redirectToInvitationCode': true,
            },
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: GlobalConstants.of(context).screenHorizontalSpace,
          vertical: 8,
        ),
        color: Colors.black12.withOpacity(0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/add-user-plus.png',
                  width: 23,
                  height: 18,
                ),
                SizedBox(
                  width: 18,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.inviteYourFriends,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.earnOOzWhenTheySignup,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff003694),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 13,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
