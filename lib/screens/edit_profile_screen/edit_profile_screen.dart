import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'US';
  PhoneNumber number = PhoneNumber(isoCode: 'US');
  double _currentSliderValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(
              height: 18,
            ),
            CircleAvatar(
              radius: 114,
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
                maxLines: 5,
                decoration: GlobalConstants.of(context).loginInputTheme('')),
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
                print(number.phoneNumber);
              },
              onInputValidated: (bool value) {
                print(value);
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.DIALOG,
              ),
              initialValue: number,
              textFieldController: controller,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
            ),
            SizedBox(
              height: 11,
            ),
            Text(
              AppLocalizations.of(context)!.personalGoal,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 11,
            ),
            Center(
              child: Text(AppLocalizations.of(context)!.minutesPerDay),
            ),
            SfSlider(
              min: 0.0,
              max: 60,
              value: _currentSliderValue,
              interval: 10,
              showLabels: true,
              showDividers: true,
              minorTicksPerInterval: 0,
              onChanged: (dynamic value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
