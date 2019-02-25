import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/components/common/custom_button.dart';

class ChooseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomButton.withTheme(
            onPressed: () {
              Navigator.of(context).pushNamed("/appRemote");
            },
            theme: Theme.of(context),
            child: Text(
              FlutterI18n.translate(context, "choose.create"),
            ),
            radius: 20,
            constraints: BoxConstraints.tight(Size(160, 40)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
          ),
          CustomButton.withTheme(
            onPressed: () {
              Navigator.of(context).pushNamed("/join");
            },
            theme: Theme.of(context),
            child: Text(
              FlutterI18n.translate(context, "choose.join"),
            ),
            radius: 20,
            constraints: BoxConstraints.tight(Size(160, 40)),
          ),
        ],
      ),
    );
  }
}
