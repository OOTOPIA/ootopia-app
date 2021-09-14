import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');

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
              decoration:
                  GlobalConstants.of(context).loginInputTheme('labelText'),
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
                maxLines: 9,
                decoration:
                    GlobalConstants.of(context).loginInputTheme('labelText')),
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
            Row(
              children: [
                InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    print(number.phoneNumber);
                  },
                  onInputValidated: (bool value) {
                    print(value);
                  },
                  selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: TextStyle(color: Colors.black),
                  initialValue: number,
                  textFieldController: controller,
                  formatInput: false,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputBorder: OutlineInputBorder(),
                  onSaved: (PhoneNumber number) {
                    print('On Saved: $number');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
