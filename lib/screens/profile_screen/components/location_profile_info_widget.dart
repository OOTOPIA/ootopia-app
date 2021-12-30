import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ootopia_app/screens/profile_screen/components/gaming_data_widget.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_screen_store.dart';
import 'package:ootopia_app/shared/global-constants.dart';

class LocationProfileInfoWidget extends StatelessWidget {
  final bool isVisible;
  final ProfileScreenStore? profileScreenStore;
  const LocationProfileInfoWidget({
    Key? key,
    required this.isVisible,
    this.profileScreenStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: isVisible
          ? Container(
              width: double.maxFinite,
              height: 54,
              margin: EdgeInsets.only(
                  bottom: GlobalConstants.of(context).spacingNormal),
              padding: EdgeInsets.symmetric(
                  horizontal:
                      GlobalConstants.of(context).screenHorizontalSpace),
              decoration:
                  BoxDecoration(color: Color(0xff707070).withOpacity(.05)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GamingDataWidget(
                    title: AppLocalizations.of(context)!.personal,
                    icon: FeatherIcons.user,
                    amount: profileScreenStore == null
                        ? 0
                        : profileScreenStore!.profile!.personalTrophyQuantity!,
                    colorIcon: Color(0xff00A5FC),
                  ),
                  GamingDataWidget(
                    title: AppLocalizations.of(context)!.city,
                    icon: FeatherIcons.mapPin,
                    amount: profileScreenStore == null
                        ? 0
                        : profileScreenStore!.profile!.cityTrophyQuantity!,
                    colorIcon: Color(0xff0072C5),
                  ),
                  GamingDataWidget(
                    title: AppLocalizations.of(context)!.planetary,
                    icon: FeatherIcons.globe,
                    amount: profileScreenStore == null
                        ? 0
                        : profileScreenStore!.profile!.globalTrophyQuantity!,
                    colorIcon: Color(0xff012588),
                  ),
                ],
              ))
          : SizedBox(),
    );
  }
}
