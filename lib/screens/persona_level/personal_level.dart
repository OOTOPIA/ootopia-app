import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/persona_level/ripple_animationA.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class PersonaLevel extends StatefulWidget {
  final double percent;

  const PersonaLevel({ required this.percent});

  @override
  _PersonaLevelState createState() => _PersonaLevelState();
}

class _PersonaLevelState extends State<PersonaLevel> {
  late AuthStore? authStore;
  late String urlImage;



  _init(BuildContext context){
    authStore = Provider.of<AuthStore>(context);
    urlImage = authStore?.currentUser?.photoUrl ?? '';
  }


  @override
  Widget build(BuildContext context) {
    _init(context);
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height - (180 + 59 + 8),
        width: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/map.png',
              ),
              //alignment: Alignment.centerLeft,
              alignment: Alignment(-0.5, -1.0),
              fit: BoxFit.cover,
            )),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.width/3),
                height: MediaQuery.of(context).size.width/3,
                width: MediaQuery.of(context).size.width/3,
                color: Colors.transparent,
                child: Stack(
                  children: [
                    RipplesAnimation(
                      color: Color(0xffB1E3FD),
                      size: MediaQuery.of(context).size.width/3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: urlImage.isEmpty
                            ? Image.asset(
                          'assets/icons/user.png',
                          height: MediaQuery.of(context).size.width/3 - MediaQuery
                              .of(context).size.width/9,
                          fit: BoxFit.cover,
                        )
                            : Image.network(
                          urlImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: CircularPercentIndicator(
                          radius: MediaQuery.of(context).size.width/3 - MediaQuery.of(context).size.width/9,
                          lineWidth: 6,
                          backgroundColor: Color(0xffFAFAFA),
                          percent:   widget.percent,
                          linearGradient: LinearGradient(colors: [Color(0xff3ABBFE), Color(0xff002E7D)],)),
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
