import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PolicyAndTermsScreen extends StatefulWidget {
  final String filename;
  final Function onAccept;
  PolicyAndTermsScreen({
    required this.filename,
    required this.onAccept,
    Key? key,
  }) : super(key: key);

  @override
  _PolicyAndTermsScreenState createState() => _PolicyAndTermsScreenState();
}

class _PolicyAndTermsScreenState extends State<PolicyAndTermsScreen> {
  late WebViewController _controller;
  String languageSuffix = "en";

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    if (Platform.localeName == "pt_BR") languageSuffix = "ptbr";
  }

  _loadHtmlFromAssets() async {
    String fileText = await rootBundle
        .loadString('assets/docs/${widget.filename}_$languageSuffix.html');
    _controller.loadUrl(Uri.dataFromString(
      fileText,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _loadHtmlFromAssets();
        },
      ),
    );
  }
}
