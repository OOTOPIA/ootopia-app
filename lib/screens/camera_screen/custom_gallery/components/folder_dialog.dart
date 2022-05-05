import 'package:flutter/material.dart';
import 'package:ootopia_app/shared/list_folders.dart';

Future<MediaPathEntity?> showFolderModalBottomSheet(
    BuildContext context) async {
  final folderList = await listMediaFolders();
  return showModalBottomSheet<MediaPathEntity?>(
    context: context,
    barrierColor: Colors.black54,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: Colors.black87),
              height: 5,
              width: 40,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: folderList.length,
                itemBuilder: ((context, index) {
                  return InkWell(
                    onTap: () => Navigator.pop(context, folderList[index]),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 15.0,
                        left: 8,
                      ),
                      child: Text(folderList[index].name),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      );
    },
  );
}
