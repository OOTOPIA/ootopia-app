import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ootopia_app/data/models/learning_tracks/chapters_model.dart';

class ViewLearningTracksScreen extends StatefulWidget {
  final Map<String, dynamic> args;
  ViewLearningTracksScreen(this.args);
  @override
  _ViewLearningTracksScreenState createState() =>
      _ViewLearningTracksScreenState();
}

class _ViewLearningTracksScreenState extends State<ViewLearningTracksScreen> {
  @override
  Widget build(BuildContext context) {
    List<ChaptersModel> listChapters = widget.args['list_chapters'];
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Card(
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: listChapters.length,
                  itemBuilder: (context, index) {
                    var chapter = listChapters[index];
                    var haveSvg = chapter.videoThumbUrl.contains('.svg');
                    return Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          color: Colors.amber,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            child: haveSvg
                                ? SvgPicture.network(
                                    chapter.videoThumbUrl,
                                    width: 80,
                                    height: 80,
                                  )
                                : Image.network(
                                    chapter.videoThumbUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              listChapters[index].title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${listChapters[index].ooz} min',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                CircleAvatar(
                                  radius: 1,
                                  backgroundColor: Colors.grey,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                SvgPicture.asset(
                                  'assets/icons/ooz_mini_blue.svg',
                                  height: 10,
                                  width: 19.33,
                                  color: Color(0xffA3A3A3),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  '${listChapters[index].ooz.toString().replaceAll('.', ',')}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
