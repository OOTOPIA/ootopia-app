import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/friends/friends_store.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:contacts_service/contacts_service.dart';

Future<void> askPermissions(BuildContext context, FriendsStore store) async {
  PermissionStatus permission = await Permission.contacts.status;
  print(permission);
  if (permission != PermissionStatus.granted &&
      permission != PermissionStatus.permanentlyDenied) {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            titleTextStyle: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(color: Color(0xff003694)),
            ),
            title: Text(
              AppLocalizations.of(context)!.accessToContact,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.discribeAccessToContact,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff003694),
                    maximumSize: Size(318, 48),
                    minimumSize: Size(318, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Color(0xff003694)),
                    ),
                  ),
                  onPressed: () async {
                    PermissionStatus permissionRequest =
                        await Permission.contacts.request();
                    if (permission != PermissionStatus.granted &&
                        permission != PermissionStatus.permanentlyDenied) {
                      List<Contact> contacts =
                          await ContactsService.getContacts();
                      List<String> sendEmailToApi = [];
                      List<String> sendPhoneToApi = [];

                      contacts.forEach((element) {
                        element.emails?.forEach((element) {
                          sendEmailToApi.add(element.value!);
                        });
                        element.phones?.forEach((element) {
                          sendPhoneToApi.add(element.value!);
                        });
                      });
                      store.emailContact.addAll(sendEmailToApi);
                      store.phoneContact.addAll(sendPhoneToApi);

                      Navigator.pop(context);
                      await store.sendContactsToApi();
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.permittedAccess,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                // TextButton(
                //   onPressed: () async {
                //     await Permission.contacts.status;
                //   },
                //   child: Text(
                //     AppLocalizations.of(context)!.notPermittedAccess,
                //     style: TextStyle(
                //       fontSize: 14,
                //       fontWeight: FontWeight.w500,
                //       color: Color(0xff707070),
                //     ),
                //   ),
                // )
              ],
            ),
          );
        });
  }
}
