import 'package:flutter/material.dart';
import 'package:crisp/crisp.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:ootopia_app/app_config.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/chat_with_users/chat_dialog_controller.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class ChatWithUsersScreen extends StatefulWidget {
  ChatWithUsersScreen({Key? key}) : super(key: key);

  @override
  _ChatWithUsersScreenState createState() => _ChatWithUsersScreenState();
}

class _ChatWithUsersScreenState extends State<ChatWithUsersScreen> {
  late AuthStore authStore;
  late CrispMain crispMain;
  late AppConfig appConfig;
  String? appVersion;

  bool crispIsInitialized = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _initializeCrisp());
  }

  _initializeCrisp() async {
    ChatDialogController.instance.setChatOpened(true);

    if (authStore.currentUser == null) {
      authStore.checkUserIsLogged();
    }

    await getAppInfo();

    Future.delayed(Duration(milliseconds: 300), () {
      crispMain = CrispMain(
        websiteId: appConfig.crispWebsiteId,
        locale: 'pt-br',
      );

      if (authStore.currentUser != null) {
        crispMain.register(
          user: CrispUser(
            email: authStore.currentUser!.email!,
            avatar: authStore.currentUser!.photoUrl,
            nickname: authStore.currentUser!.fullname,
          ),
        );
      }

      Map<String, String> sessionData = {};

      if (appVersion != null) {
        sessionData['app_version'] = appVersion!;
      }

      crispMain.setSessionData(sessionData);

      setState(() {
        crispIsInitialized = true;
      });
    });
  }

  Future<String> getAppInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    return this.appVersion = info.version;
  }

  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);
    appConfig = AppConfig.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.all(3),
            child: Image.asset(
              'assets/images/logo.png',
              height: 34,
            ),
          ),
          toolbarHeight: 45,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          brightness: Brightness.light,
          leading: Padding(
            padding: EdgeInsets.only(
              left: GlobalConstants.of(context).screenHorizontalSpace - 9,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        body: !crispIsInitialized
            ? Center(
                child: CircularProgressIndicator(),
              )
            : CrispView(
                // appBar: AppBar(
                //   title: const Text('OOTOPIA'),
                // ),
                // loadingWidget: Center(
                //   child: CircularProgressIndicator(),
                // ),
                crispMain: crispMain,
              ),
      ),
    );
  }
}
