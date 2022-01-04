import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/profile_screen/components/album_profile_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/shared/global-constants.dart';

class ProfileAlbumListWidget extends StatelessWidget {
  const ProfileAlbumListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: GlobalConstants.of(context).screenHorizontalSpace - 6),
      child: Row(
        children: [
          AlbumProfileWidget(
            onTap: () {},
            albumName: AppLocalizations.of(context)!.all2,
            photoAlbumUrl: "",
          ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(PageRoute.Page.newFutureCategories.route);
            },
            child: AlbumProfileWidget(
              onTap: () {},
              albumName: AppLocalizations.of(context)!.album,
            ),
          )
        ],
      ),
    );
  }
}
