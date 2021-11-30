import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/design_guide/buttons.dart';

class PolicyAndTermsScreen extends StatefulWidget {
  final String filename;
  final Function onAccept;
  String? buttonText = "";
  String? fileSuffix = "";
  PolicyAndTermsScreen({
    required this.filename,
    required this.onAccept,
    this.buttonText,
    this.fileSuffix,
    Key? key,
  }) : super(key: key);

  @override
  _PolicyAndTermsScreenState createState() => _PolicyAndTermsScreenState();
}

class _PolicyAndTermsScreenState extends State<PolicyAndTermsScreen> {
  late WebViewController _controller;
  String languageSuffix = "en";
  bool showWebViewTrick = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    if (Platform.localeName == "pt_BR") languageSuffix = "ptbr";
  }

  _loadHtmlFromAssets() async {
    String fileText = "";
    if (widget.fileSuffix != null && widget.fileSuffix!.isNotEmpty) {
      fileText = await rootBundle.loadString(
          'assets/docs/${widget.filename}_${languageSuffix}_${widget.fileSuffix}.html');
    } else {
      fileText = await rootBundle
          .loadString('assets/docs/${widget.filename}_$languageSuffix.html');
    }
    _controller.loadUrl(Uri.dataFromString(
      fileText,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AnimatedOpacity(
                opacity: showWebViewTrick ? 1 : 0,
                duration: Duration(milliseconds: 200),
                child: WebView(
                  initialUrl: 'about:blank',
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller = webViewController;
                    _loadHtmlFromAssets();
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(
                        GlobalConstants.of(context).screenHorizontalSpace + 2),
                    child: ElevatedButton(
                      child: Text(
                        widget.buttonText != null &&
                                widget.buttonText!.isNotEmpty
                            ? widget.buttonText as String
                            : AppLocalizations.of(context)!.iAccept,
                        style: Theme.of(context)
                            .inputDecorationTheme
                            .hintStyle!
                            .copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      onPressed: () {
                        close();
                        widget.onAccept();
                      },
                    ).defaultButton(
                      context,
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(0.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  close() {
    setState(() {
      showWebViewTrick = false;
    });
    Navigator.of(context).pop();
  }

  get appBar => AppBar(
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.all(3),
          child: Image.asset(
            'assets/images/logo.png',
            height: 34,
          ),
        ),
        toolbarHeight: 45,
        elevation: 2,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        brightness: Brightness.light,
        leading: Padding(
          padding: EdgeInsets.only(
            left: GlobalConstants.of(context).screenHorizontalSpace - 9,
          ),
          child: InkWell(
            onTap: () => close(),
            child: Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: Row(
                children: [
                  Icon(
                    FeatherIcons.arrowLeft,
                    color: Colors.black,
                    size: 20,
                  ),
                  Text(
                    AppLocalizations.of(context)!.back,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
