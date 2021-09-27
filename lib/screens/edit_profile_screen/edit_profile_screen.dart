import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/edit_profile_screen/edit_profile_store.dart';
import 'package:ootopia_app/screens/home/components/page_view_controller.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_screen_store.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  EditProfileStore editProfileStore = EditProfileStore();
  late ProfileScreenStore profileStore;
  late AuthStore authStore;
  PhoneNumber? codeCountryPhoneNnumber;
  File? filePath;
  SmartPageController controller = SmartPageController.getInstance();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await editProfileStore.getUser();
      codeCountryPhoneNnumber = PhoneNumber(
          isoCode: editProfileStore.countryCode,
          phoneNumber: editProfileStore.cellPhoneController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    profileStore = Provider.of<ProfileScreenStore>(context);
    authStore = Provider.of<AuthStore>(context);
    return Observer(builder: (context) {
      return LoadingOverlay(
        isLoading: editProfileStore.isloading,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 150),
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        controller.back();
                      },
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.black,
                      ),
                      label: Text(
                        AppLocalizations.of(context)!.editProfile,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        await editProfileStore.updateUser();
                        await profileStore.getProfileDetails(
                            editProfileStore.currentUser!.id!);
                        authStore.setUserIsLogged();
                        controller.back();
                      },
                      icon: Icon(
                        Icons.check,
                        color: Color(0xff03DAC5),
                      ),
                      label: Text(
                        AppLocalizations.of(context)!.save,
                        style: TextStyle(color: Color(0xff03DAC5)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: editProfileStore.formKey,
              child: ListView(
                children: [
                  SizedBox(
                    height: 18,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.white,
                                width: 4.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: filePath == null
                                ? editProfileStore.photoUrl == null
                                    ? CircleAvatar(
                                        radius: 57,
                                        backgroundImage: AssetImage(
                                            'assets/icons_profile/profile.png'),
                                      )
                                    : CircleAvatar(
                                        radius: 57,
                                        backgroundImage: NetworkImage(
                                            editProfileStore.photoUrl
                                                .toString()),
                                      )
                                : CircleAvatar(
                                    radius: 57,
                                    backgroundImage: Image.file(
                                      filePath!,
                                      fit: BoxFit.cover,
                                    ).image,
                                  ),
                          ),
                        ),
                        Positioned(
                            bottom: 7,
                            right: 37,
                            child: InkWell(
                              onTap: () async {
                                final ImagePicker _picker = ImagePicker();
                                // Pick an image
                                final image = await _picker.getImage(
                                    source: ImageSource.gallery);

                                final File file = File(image!.path);
                                setState(() {
                                  filePath = file;
                                  editProfileStore.photoFilePathLocal =
                                      image.path;
                                });
                              },
                              child: Container(
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: new Border.all(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                    backgroundColor: Color(0xff03DAC5),
                                    radius: 20,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 22,
                                      color: Colors.white,
                                    )),
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    AppLocalizations.of(context)!.fullName,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration: GlobalConstants.of(context).loginInputTheme(''),
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
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                      controller: editProfileStore.bioController,
                      maxLines: 5,
                      decoration:
                          GlobalConstants.of(context).loginInputTheme('')),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    AppLocalizations.of(context)!.mobilePhone,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      setState(() {
                        editProfileStore.countryCode =
                            number.isoCode.toString();
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
                    textFieldController: editProfileStore.cellPhoneController,
                    formatInput: true,
                    initialValue: codeCountryPhoneNnumber,
                    errorMessage:
                        AppLocalizations.of(context)!.mobilephoneToExperience,
                    inputBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(width: 0.25),
                    ),
                    scrollPadding: EdgeInsets.all(0),
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputDecoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(width: 0.25),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(width: 0.25),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide:
                            BorderSide(width: 0.25, color: Color(0xff8E1816)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide:
                            BorderSide(width: 0.25, color: Color(0xff8E1816)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    AppLocalizations.of(context)!.personalGoal,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                          text: AppLocalizations.of(context)!.aboutChooseZero,
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
                  SfSliderTheme(
                    data: SfSliderThemeData(
                        activeTrackColor: Color(0xff03DAC5).withOpacity(0.1),
                        inactiveTrackColor: Color(0xff03DAC5),
                        inactiveDividerRadius: 5,
                        minorTickSize: Size(20, 20),
                        tickSize: Size(12, 20),
                        thumbColor: Colors.white,
                        activeDividerColor: Color(0xff03DAC5).withOpacity(0.1),
                        activeTickColor: Color(0xff03DAC5).withOpacity(0.1),
                        overlayColor: Color(0xff03DAC5),
                        activeDividerStrokeColor: Color(0xff03DAC5),
                        disabledActiveDividerColor: Color(0xff03DAC5),
                        thumbStrokeColor: Color(0xff03DAC5),
                        inactiveTickColor: Color(0xff03DAC5),
                        disabledThumbColor: Color(0xff03DAC5),
                        activeMinorTickColor: Color(0xff03DAC5),
                        inactiveDividerColor: Color(0xff03DAC5),
                        overlayRadius: 20,
                        activeDividerStrokeWidth: 20,
                        inactiveDividerStrokeWidth: 20,
                        inactiveTrackHeight: 9,
                        trackCornerRadius: 9,
                        tickOffset: Offset(20, 20)),
                    child: SfSlider(
                      min: 0.0,
                      max: 60,
                      value: editProfileStore.currentSliderValue,
                      interval: 10,
                      stepSize: 10,
                      showLabels: true,
                      showDividers: true,
                      enableTooltip: true,
                      inactiveColor: Color(0xff03DAC5).withOpacity(0.3),
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
      );
    });
  }
}
