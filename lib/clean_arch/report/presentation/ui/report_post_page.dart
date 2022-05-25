import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ootopia_app/clean_arch/report/presentation/stores/store_report_post.dart';
import 'package:provider/provider.dart';

class ReportPostPage extends StatefulWidget {
  const ReportPostPage({Key? key}) : super(key: key);

  @override
  State<ReportPostPage> createState() => _ReportPostPageState();
}

class _ReportPostPageState extends State<ReportPostPage> {
  @override
  Widget build(BuildContext context) {
    final StoreReportPost _storeReportPost = Provider.of(context);

    return SingleChildScrollView(
      child: Observer(builder: (context) {
        return Column(
          children: [
            CheckboxListTile(
              value: _storeReportPost.spam,
              onChanged: _storeReportPost.setSpam,
              title: Text(''),
            ),
            CheckboxListTile(
              value: _storeReportPost.nudez,
              onChanged: _storeReportPost.setNudez,
              title: Text(''),
            ),
            CheckboxListTile(
              value: _storeReportPost.violence,
              onChanged: _storeReportPost.setViolence,
              title: Text(''),
            ),
            CheckboxListTile(
              value: _storeReportPost.outher,
              onChanged: _storeReportPost.setOuther,
              title: Text(''),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(''),
            ),
          ],
        );
      }),
    );
  }
}
