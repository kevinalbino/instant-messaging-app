import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

enum DialogsAction { yes, cancel }

class popUpView {
  static Future<DialogsAction> yesCancelDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(DialogsAction.cancel),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w500),
              )
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(DialogsAction.yes),
              child: const Text(
                'Confirm',
                style: TextStyle(fontWeight: FontWeight.w500),
              )
            ),
          ],
        );
      }
    );
    return (action != null) ? action : DialogsAction.cancel;
  }
}
