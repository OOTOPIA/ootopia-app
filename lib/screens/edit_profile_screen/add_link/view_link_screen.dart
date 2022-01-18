import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/data/models/users/link_model.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_avatar_widget.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_screen_store.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewLinksScreen extends StatefulWidget {

  final Map<String, dynamic> args;
  late ProfileScreenStore store;
  late List<Link> links;
  ViewLinksScreen(this.args){
    store = args['store'];
    links = args['list'];
  }

  @override
  _ViewLinksScreenState createState() => _ViewLinksScreenState();
}

class _ViewLinksScreenState extends State<ViewLinksScreen> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            BackgroundButterflyTop(positioned: -59),
            BackgroundButterflyBottom(),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: GlobalConstants.of(context).spacingNormal,
                  ),
                  ProfileAvatarWidget(profileScreenStore: widget.store),
                  SizedBox(
                      height: GlobalConstants.of(context).spacingSmall),
                  Text(
                    widget.store.profile!.fullname,
                    style: GoogleFonts.roboto(
                        color: Theme.of(context).textTheme.subtitle1!.color,
                        fontSize: 24,
                        fontWeight: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .fontWeight),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.links.length,
                    itemBuilder: (context, index) {
                      return urlItem(widget.links[index]);
                    },
                  )
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget urlItem(Link link) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(width: 1, color: LightColors.grey.withOpacity(0.5)),
      ),
      child: Material(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Ink(
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            onTap: (){
              _launchURL(link.URL);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 12),
                  SvgPicture.asset('assets/icons/link.svg'),
                  SizedBox(width: 12),
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 100),
                    child: Text(
                      link.title,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 20,
                          color: LightColors.grey,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _launchURL(String _url) async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

}
