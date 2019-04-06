import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

Widget loadingIndicator({BuildContext context, String messageKey}) {
  if (context == null || messageKey == null) {
    return Center(child: CircularProgressIndicator());
  }

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Padding(padding: EdgeInsets.only(top: 10)),
        Text(FlutterI18n.translate(context, messageKey)),
      ],
    ),
  );
}
