import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/data/models/learning_tracks/chapters_model.dart';

class ViewLearningTracksScreen extends StatefulWidget {
  final Map<String, dynamic> args;
  ViewLearningTracksScreen(this.args);
  @override
  _ViewLearningTracksScreenState createState() =>
      _ViewLearningTracksScreenState();
}

class _ViewLearningTracksScreenState extends State<ViewLearningTracksScreen> {
  final currencyFormatter = NumberFormat('#,##0.00', 'ID');
  @override
  Widget build(BuildContext context) {
    List<ChaptersModel> listChapters = widget.args['list_chapters'];
    String description = widget.args['description'];
    String title = widget.args['title'];
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 24),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Image.asset(
                'assets/images/ootopia-learning-track.png',
                width: double.infinity,
              ),
              Container(
                margin: EdgeInsets.only(top: 120),
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18, bottom: 16),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          '$title',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Text(
                          "$description",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: listChapters.length,
                            itemBuilder: (context, index) {
                              var chapter = listChapters[index];
                              var haveSvg =
                                  chapter.videoThumbUrl.contains('.svg');
                              return InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {},
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 16.5,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
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
                                              Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  decoration:
                                                      BoxDecoration(boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 20,
                                                      color: Colors.black
                                                          .withOpacity(0.16),
                                                      offset: Offset(0, 3),
                                                      spreadRadius: 0,
                                                    )
                                                  ]),
                                                  child: Icon(
                                                    Icons.play_arrow,
                                                    color: Colors.white,
                                                    size: 35,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  chapter.title,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${chapter.timeInMinutes} min',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  CircleAvatar(
                                                    radius: 1,
                                                    backgroundColor:
                                                        Colors.grey,
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
                                                    '${currencyFormatter.format(chapter.ooz)}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    index == listChapters.length - 1
                                        ? Container()
                                        : Divider(
                                            color: Colors.grey,
                                          ),
                                  ],
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
