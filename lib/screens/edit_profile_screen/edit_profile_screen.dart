import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ootopia_app/screens/edit_profile_screen/edit_profile_store.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  EditProfileStore editProfileStore = EditProfileStore();
  File? filePath;
  @override
  void initState() {
    super.initState();
    editProfileStore.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(builder: (_) {
        if (editProfileStore.isloading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Form(
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
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: editProfileStore.photoUrl == null
                              ? filePath == null
                                  ? CircleAvatar(
                                      radius: 57,
                                      backgroundImage: AssetImage(
                                          'assets/icons_profile/profile.png'),
                                    )
                                  : CircleAvatar(
                                      radius: 114,
                                      backgroundImage: Image.file(
                                        filePath!,
                                        fit: BoxFit.cover,
                                      ).image,
                                      //child: Image.file(filePath!),
                                    )
                              : CircleAvatar(
                                  radius: 114,
                                  backgroundImage: NetworkImage(
                                      editProfileStore.photoUrl.toString()),
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
                    editProfileStore.getPhoneNumber(number.toString(), 'br');
                  },
                  onInputValidated: (bool value) {
                    print(value);
                  },
                  selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'falso';
                    }
                    return null;
                  },
                  textFieldController: editProfileStore.cellPhoneController,
                  formatInput: true,
                  scrollPadding: EdgeInsets.all(0),
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
                    AppLocalizations.of(context)!.chooseTimeForRegenerationGame,
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
                  height: 15,
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
        );
      }),
    );
  }
}
