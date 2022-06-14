import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/stores/create_posts_stores.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorGetGeolocation extends StatelessWidget {
  ErrorGetGeolocation({
    Key? key,
  }) : super(key: key);

  final StoreCreatePosts _storeCreatePosts = GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: GlobalConstants.of(context).spacingNormal,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: GlobalConstants.of(context).spacingNormal),
        width: double.infinity,
        child: Column(
          children: [
            ElevatedButton(
              child: Padding(
                padding: EdgeInsets.all(
                  GlobalConstants.of(context).spacingNormal,
                ),
                child: Text(
                  AppLocalizations.of(context)!.getCurrentLocation,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              onPressed: () {
                _storeCreatePosts.getLocation(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color(0xff707070),
                    width: .25,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: GlobalConstants.of(context).spacingNormal,
                horizontal: GlobalConstants.of(context).screenHorizontalSpace,
              ),
              child: Text(
                _storeCreatePosts.geolocationErrorMessage +
                    AppLocalizations.of(context)!
                        .tryToRetrieveYourCurrentLocationClickingByGetLocationAgain,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
