import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  ViewLinksScreen(this.args){
    store = args['store'];
  }

  @override
  _ViewLinksScreenState createState() => _ViewLinksScreenState();
}

class _ViewLinksScreenState extends State<ViewLinksScreen> {
  List links = ['asasas', 'asasas' ,'asasas','asasas','asasas','asasas','asas'
      'as','asasas'];



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
                    itemCount: links.length,
                    itemBuilder: (context, index) {
                      return urlItem(links[index]);
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

  Widget urlItem(link) {
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
              //TODO POR O LINK
              _launchURL('https://www.google.com');
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 12),
                  Icon(
                    //TODO TROCAR ICONE
                    Icons.link,
                    color: LightColors.blue,
                  ),
                  SizedBox(width: 12),
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 100),
                    child: Text(
                      //TODO PEGAR NOME
                      link,
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
