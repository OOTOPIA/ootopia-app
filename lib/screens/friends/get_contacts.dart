import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/friends/friends_store.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:contacts_service/contacts_service.dart';

Future<void> askPermissions(BuildContext context, FriendsStore store) async {
  await showDialog(
      context: context,
      barrierDismissible: false,
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
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.accessToContact,
                ),
              ),
              IconButton(
                  onPressed: () async {
                    PermissionStatus permission =
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
                    } else {
                      Navigator.pop(context);
                      await store.sendContactsToApi();
                    }
                  },
                  icon: Icon(Icons.close))
            ],
          ),
          content: Text(
            AppLocalizations.of(context)!.discribeAccessToContact,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        );
      });
}

void requestContacts(FriendsStore store, context) async {}
