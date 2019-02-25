import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

void showFailedAlert(BuildContext context, String message, VoidCallback onOk) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
          title: Text(
            FlutterI18n.translate(context, "errors.title"),
            style: Theme.of(context).textTheme.subhead,
          ),
          content: SingleChildScrollView(
            child: Text(
              message,
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                FlutterI18n.translate(context, "ok"),
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: onOk,
            )
          ],
        ),
  );
}
