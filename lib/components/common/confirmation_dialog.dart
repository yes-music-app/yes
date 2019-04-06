import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

void showConfirmationDialog(
  BuildContext context,
  String messageKey,
  String confirmationKey,
  String cancelKey,
  VoidCallback onConfirm,
  VoidCallback onCancel,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
          content: SingleChildScrollView(
            child: Text(
              FlutterI18n.translate(context, messageKey),
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                FlutterI18n.translate(context, cancelKey),
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                onCancel();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                FlutterI18n.translate(context, confirmationKey),
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
  );
}
