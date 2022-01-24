import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/data/models/users/link_model.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/screens/components/photo_edit.dart';
import 'package:ootopia_app/screens/edit_profile_screen/edit_profile_store.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_screen_store.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();

  late ProfileScreenStore profileStore;
  late AuthStore authStore;
  late EditProfileStore editProfileStore;
  PhoneNumber? codeCountryPhoneNnumber;
  SmartPageController controller = SmartPageController.getInstance();
  @override
  void initState() {
    super.initState();
    editProfileStore = Provider.of<EditProfileStore>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      await editProfileStore.getUser();
      codeCountryPhoneNnumber = PhoneNumber(
          isoCode: editProfileStore.countryCode,
          phoneNumber: editProfileStore.cellPhoneController.text);
    });
  }
  bool newLinks = false;



  void updateLinks(){
    bool newListLinks = editProfileStore.links.length != profileStore.profile?.links?.length;
    if(!newLinks && (editProfileStore.links.isEmpty || newListLinks)){
      editProfileStore.links = profileStore.profile?.links ?? [];
    }

    setTextToShowFromLinks();
  }

  void setTextToShowFromLinks(){
    editProfileStore.links.forEach((element) {
      element.textToShow = "${element.title}: ${element.URL}";
      bool status = true;
      final style = TextStyle(fontSize: 16, color: LightColors.grey);
      final span = TextSpan(text: element.textToShow , style: style);
      final tp = TextPainter(text: span, maxLines: 1, textDirection: TextDirection.ltr);
      tp.layout(maxWidth: MediaQuery.of(context).size.width-101);

      if(tp.didExceedMaxLines){
        int i = element.textToShow!.length;

        while(status){
          final span = TextSpan(text: element.textToShow!.substring(0,i) + "...", style: style );
          final tp = TextPainter(text: span, maxLines: 1,  textDirection: TextDirection.ltr);
          tp.layout(maxWidth: MediaQuery.of(context).size.width-101);
          i--;
          if(tp.didExceedMaxLines == false){
            status = false;
            element.textToShow = element.textToShow!.substring(0,i) + "...";
          }
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    profileStore = Provider.of<ProfileScreenStore>(context);
    updateLinks();
    authStore = Provider.of<AuthStore>(context);
    return Observer(builder: (context) {
      return LoadingOverlay(
        isLoading: editProfileStore.isloading,
        child: Scaffold(
          appBar: DefaultAppBar(
            components: [
              AppBarComponents.back,
              AppBarComponents.save,
            ],
            onTapLeading: () {
              controller.back();
            },
            onTapAction: () async {
              if (formKey.currentState!.validate()) {
                await editProfileStore.updateUser();
                await profileStore
                    .getProfileDetails(editProfileStore.currentUser!.id!);
                authStore.setUserIsLogged();
                controller.back();
              }
            },
          ),
          body: Stack(
            children: [
              BackgroundButterflyTop(positioned: -59),
              Visibility(
                  visible: MediaQuery.of(context).viewInsets.bottom == 0,
                  child: BackgroundButterflyBottom(positioned: -50)),
              SafeArea(
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: formKey,
                      child: ListView(
                        children: [
                          SizedBox(
                            height: GlobalConstants.of(context).spacingNormal,
                          ),

                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              child: PhotoEdit(
                                photoUrl: editProfileStore.photoUrl.toString(),
                                updatePhoto: (String? imagePath) async {
                                  if (imagePath != null) {
                                    setState(() {
                                      editProfileStore.photoFilePathLocal =
                                          imagePath;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Text(AppLocalizations.of(context)!.fullName,
                              style: GoogleFonts.roboto(
                                  fontSize: 16, fontWeight: FontWeight.w400)),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            style: GoogleFonts.roboto(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            decoration: GlobalConstants.of(context)
                                .loginInputTheme('')
                                .copyWith(),
                            controller: editProfileStore.fullNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterYourNameAndSurname;
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),

                          Text(
                            AppLocalizations.of(context)!.bio,
                            style: GoogleFonts.roboto(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              style: GoogleFonts.roboto(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                              controller: editProfileStore.bioController,
                              maxLines: 5,
                              decoration: GlobalConstants.of(context)
                                  .loginInputTheme(
                                      AppLocalizations.of(context)!.optional)
                                  .copyWith(
                                      labelStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.2)),
                                      alignLabelWithHint: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 16))),
                          SizedBox(
                            height: 16,
                          ),

                          Text(
                            AppLocalizations.of(context)!.links,
                            style: GoogleFonts.roboto(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          GestureDetector(
                            onTap: () async {
                              List<Link>? list = await  Navigator.of(context)
                                  .pushNamed(
                                  PageRoute.Page.addLink.route,
                                  arguments: {
                                    "list": editProfileStore.links
                                  }
                              ) as List<Link>?;
                              if(list != null){
                                if(list.isEmpty){
                                  setState(() {
                                    editProfileStore.links.removeWhere((element) => true);
                                    newLinks = true;
                                  });
                                }else{
                                  setState(() {
                                    editProfileStore.links = list;
                                    newLinks = true;
                                  });
                                }
                              }
                            },
                            child: TextFormField(
                                textCapitalization: TextCapitalization.sentences,
                                style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
                                maxLines: 1,
                                enabled: false,
                                decoration: GlobalConstants.of(context)
                                    .loginInputTheme(
                                    AppLocalizations.of(context)!.addLinksInYourPage).copyWith(
                                    prefixIcon: Container(
                                      height: 21,
                                      width: 21,
                                      margin: EdgeInsets.all(15),
                                      child: SvgPicture.asset(
                                        'assets/icons/mais.svg',
                                        height: 21,
                                        width: 21,),
                                    ),
                                    suffixIcon:  Visibility(
                                      visible: editProfileStore.links.length > 0,
                                      child: Container(
                                        margin: EdgeInsets.symmetric
                                          (horizontal: 16, vertical: 16),
                                        child: Text(
                                          "${editProfileStore.links.length} "
                                              "${AppLocalizations.of(context)!
                                              .added}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: LightColors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    labelStyle: TextStyle(color: Colors.black),
                                    alignLabelWithHint: true,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16))),
                          ),

                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: editProfileStore.links.length,
                            itemBuilder: (context, index) {
                              return urlItem(editProfileStore.links[index]);
                            },
                          ),

                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            AppLocalizations.of(context)!.mobilePhone,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 11,
                          ),
                          InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
                              setState(() {
                                editProfileStore.countryCode =
                                    number.isoCode.toString();
                                editProfileStore.dialCode =
                                    number.dialCode.toString();
                                editProfileStore.getPhoneNumber(
                                    number.toString(), number.isoCode.toString());
                              });
                            },
                            onInputValidated: (bool value) {
                              setState(() {
                                editProfileStore.validCellPhone = !value;
                              });
                            },
                            selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                              showFlags: true,
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.contains('+')) {
                                return AppLocalizations.of(context)!
                                    .mobilephoneToExperience;
                              } else if (editProfileStore.validCellPhone) {
                                return AppLocalizations.of(context)!
                                    .insertValidCellPhone;
                              }
                              return null;
                            },
                            textFieldController:
                                editProfileStore.cellPhoneController,
                            formatInput: true,
                            initialValue: codeCountryPhoneNnumber,
                            textStyle: editProfileStore.validCellPhone
                                ? TextStyle(
                                    color: Color(0xff8E1816),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    overflow: null,
                                  )
                                : TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                            errorMessage: AppLocalizations.of(context)!
                                .mobilephoneToExperience,
                            inputBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              borderSide:
                                  BorderSide(width: 0.25, color: Colors.grey),
                            ),
                            scrollPadding: EdgeInsets.all(0),
                            autoValidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            inputDecoration: InputDecoration(
                              fillColor: Colors.white.withOpacity(0.75),
                              hintText:
                                  AppLocalizations.of(context)!.enterYourNumber,
                              hintStyle:
                                  TextStyle(color: Colors.black.withOpacity(0.2)),
                              errorMaxLines: 4,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide:
                                    BorderSide(width: 0.25, color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide:
                                    BorderSide(width: 0.25, color: Colors.grey),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide:
                                    BorderSide(width: 1, color: Color(0xff8E1816)),
                              ),
                              errorStyle: TextStyle(
                                color: Color(0xff8E1816),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                overflow: TextOverflow.visible,
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide:
                                    BorderSide(width: 1, color: Color(0xff8E1816)),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide:
                                    BorderSide(width: 1, color: Color(0xff8E1816)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            AppLocalizations.of(context)!.personalGoal,
                            style: GoogleFonts.roboto(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                              AppLocalizations.of(context)!
                                  .chooseTimeForRegenerationGame,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              )),
                          SizedBox(
                            height: 32,
                          ),
                          RichText(
                              text: TextSpan(
                            children: [
                              TextSpan(
                                  text: AppLocalizations.of(context)!.note,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  )),
                              TextSpan(
                                  text:
                                      AppLocalizations.of(context)!.aboutChooseZero,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  )),
                            ],
                          )),
                          SizedBox(
                            height: 16,
                          ),
                          Center(
                            child: Text(
                              AppLocalizations.of(context)!.minutesPerDay,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          SfSliderTheme(
                            data: SfSliderThemeData(
                                activeTrackColor:
                                    Color(0xff03DAC5).withOpacity(0.08),
                                inactiveTrackColor:
                                    Color(0xff03DAC5).withOpacity(0.3),
                                inactiveDividerRadius: 4.8,
                                minorTickSize: Size(10, 10),
                                tickSize: Size(20, 20),
                                thumbColor: Colors.white,
                                activeDividerColor: Color(0xff03DAC5),
                                overlayColor: Color(0xff03DAC5),
                                activeDividerStrokeColor: Color(0xff03DAC5),
                                disabledActiveDividerColor: Color(0xff03DAC5),
                                thumbStrokeColor: Color(0xff03DAC5),
                                inactiveTickColor: Color(0xff03DAC5),
                                disabledThumbColor: Color(0xff03DAC5),
                                activeMinorTickColor: Color(0xff03DAC5),
                                inactiveDividerColor: Color(0xff03DAC5),
                                overlayRadius: 9,
                                inactiveTrackHeight: 9.5,
                                trackCornerRadius: 9,
                                tickOffset: Offset(10, 10),
                                thumbRadius: 9.3,
                                activeTrackHeight: 9.5,
                                activeLabelStyle:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                                inactiveLabelStyle:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                                activeDividerRadius: 4.8),
                            child: SfSlider(
                              min: 0.0,
                              max: 60,
                              value: editProfileStore.currentSliderValue,
                              interval: 10,
                              stepSize: 10,
                              showLabels: true,
                              showDividers: true,
                              onChanged: (dynamic value) {
                                setState(() {
                                  editProfileStore.currentSliderValue = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Visibility(
                            visible: editProfileStore.currentSliderValue == 0,
                            child: Text(
                              AppLocalizations.of(context)!.settingGoalToZero,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget urlItem(Link link) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Row(
        children: [
          SizedBox(width: 35),
          Container(
            height: 9,
            width: 9,
            decoration: BoxDecoration(
                color: Color(0xff03DAC5),
                shape: BoxShape.circle
            ),
          ),
          SizedBox(width: 8),
          Container(
            width: MediaQuery.of(context).size.width - 101,
            child: Text( link.textToShow ?? "",
            maxLines: 1,
            style: TextStyle(
              fontSize: 16,
              color: LightColors.grey


            ),),
          ),
        ],
      ),
    );
  }
}
