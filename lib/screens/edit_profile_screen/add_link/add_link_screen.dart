import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/data/models/users/link_model.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class AddLinkScreen extends StatefulWidget {
  final Map<String, dynamic> args;

  const AddLinkScreen( this.args);

  @override
  _AddLinkScreenState createState() => _AddLinkScreenState();
}

class _AddLinkScreenState extends State<AddLinkScreen> {
  SmartPageController controller = SmartPageController.getInstance();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<LinkController> url = [LinkController()];

  @override
  void initState() {
    List links = widget.args['list'];
    if(links.length > 0) {
      url.removeAt(0);
      links.forEach((element) {
        LinkController linkController = LinkController();
        linkController.urlController.text = element.URL;
        linkController.titleController.text = element.title;
        url.add(linkController);
      });
    }

    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        components: [
          AppBarComponents.back,
          AppBarComponents.save,
        ],
        onTapLeading: () {
          Navigator.of(context).pop();
        },
        onTapAction: () async {
          if(url.length == 1 && url[0].urlController.text.isEmpty &&  url[0]
              .titleController.text.isEmpty){
            List<Link> links = [];
            Navigator.of(context).pop(links);
          }else {
            if (formKey.currentState!.validate()) {
              List<Link> links = [];
              url.forEach((element) {
                links.add(Link(
                  URL: element.urlController.text,
                  title: element.titleController.text,
                ));
              });
              Navigator.of(context).pop(links);
            }
          }
        },
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            BackgroundButterflyTop(positioned: -59),
            Visibility(
                visible: MediaQuery.of(context).viewInsets.bottom == 0,
                child: BackgroundButterflyBottom()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Text(AppLocalizations.of(context)!.addLinksInYourPage,
                        style: TextStyle(
                            fontSize: 22,
                            color: LightColors.darkBlue,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 18),
                    Form(
                      key: formKey,
                      child: AnimatedSize(
                        alignment: Alignment.topCenter,
                        duration: Duration(milliseconds: 600),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: url.length,
                          itemBuilder: (context, index) {
                            return urlItem(url[index], index);
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 32),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          url.add(LinkController());
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 1.0, color: LightColors.blue),
                        primary: Colors.black,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                      ),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            child: Text(AppLocalizations.of(context)!.addOneMoreLink,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: LightColors.highlightText,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),

                    ),

                    SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 66),
                      child: Text(AppLocalizations.of(context)!.selectLinksThatCorrespond,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: LightColors.grey,
                              fontWeight: FontWeight.w400)),
                    ),


                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget urlItem(LinkController item,int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(index != 0 )...[
          SizedBox(height: 12),
          Divider(
            color: Color(0xff141414),
          ),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${AppLocalizations.of(context)!.link} ${index+1}',
                style: TextStyle(
                    fontSize: 18,
                    color: LightColors.grey,
                    fontWeight: FontWeight.w400)),
            Visibility(
                visible: url.length > 1 || (index == 0 && item.urlController.text.isNotEmpty),
                child: TextButton(
                  onPressed: (){
                    if(index == 0){
                      if(url.length == 1){
                        setState(() {
                          item.urlController.text = '';
                          item.titleController.text = '';
                        });
                      }else{
                        setState(() {
                          url.remove(item);
                        });
                      }
                    }else{
                      setState(() {
                        url.remove(item);
                      });
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.delete,
                      style: TextStyle(
                          fontSize: 14,
                          color: LightColors.errorRed,
                          fontWeight: FontWeight.w400)),
                ))
          ],
        ),
        SizedBox(height: 8),
        TextFormField(
          textCapitalization: TextCapitalization.none,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.next,
          onChanged: (text){
            if(text.length == 0 || text.length == 1){
              setState(() {

              });
            }
          },
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500),
          decoration: GlobalConstants.of(context).loginInputTheme(
              AppLocalizations.of(context)!.url.toUpperCase())
              .copyWith(),
          controller: item.urlController,

          validator: (value) {
            if(value!.contains('http') == false){
              value = 'http://' + value;
              item.urlController.text = value;
            }
            bool isUrl = Uri.tryParse(value + "/")?.hasAbsolutePath ?? false;
            if (value.isEmpty) {
              return AppLocalizations.of(context)!.pleaseEnterLink;
            }else if(!isUrl){
              return AppLocalizations.of(context)!.invalidUrl;
            }
            return null;
          },
        ),
        SizedBox(height: 8),
        TextFormField(
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500),
          decoration: GlobalConstants.of(context).loginInputTheme(
              AppLocalizations.of(context)!.title)
              .copyWith(),
          controller: item.titleController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!
                  .pleaseEnterTitle;
            }
            return null;
          },
        ),
      ],
    );
  }
}

class LinkController{
  TextEditingController urlController = TextEditingController();
  TextEditingController titleController = TextEditingController();
}
