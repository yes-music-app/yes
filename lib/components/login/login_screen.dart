import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/components/common/text_button.dart';
import 'package:yes_music/data/firebase/auth_handler_base.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color overlay = Theme.of(context).primaryColor.withAlpha(200);

    return new Container(
      decoration: _getBackground(overlay),
      child: new Center(
        child: new StreamBuilder(
            stream: null,
            builder: (
              BuildContext context,
              AsyncSnapshot<FirebaseAuthState> snapshot,
            ) {
              if (snapshot == null || !snapshot.hasData) {
                return _getConnectButtons(context);
              }

              switch (snapshot.data) {
                default:
                  return _getConnectButtons(context);
                  break;
              }
            }),
      ),
    );
  }

  BoxDecoration _getBackground(Color overlay) {
    return new BoxDecoration(
      image: new DecorationImage(
        fit: BoxFit.fitHeight,
        colorFilter: new ColorFilter.mode(overlay, BlendMode.multiply),
        image: new AssetImage("assets/login/background.png"),
      ),
    );
  }

  Widget _getConnectButtons(BuildContext context) {
    return new Container(
      constraints: new BoxConstraints.tight(new Size(160, 200)),
      child: new Column(
        children: <Widget>[
          new Text(
            FlutterI18n.translate(context, "login.connect.connectPrompt"),
            style: Theme.of(context).textTheme.headline,
          ),
          new Container(
            padding: new EdgeInsets.only(bottom: 20),
          ),
          new TextButton.withTheme(
            onPressed: () => {},
            theme: Theme.of(context),
            child: new Text(
              FlutterI18n.translate(context, "login.connect.connectGoogle"),
            ),
            radius: 20,
            constraints: new BoxConstraints.tight(new Size(160, 40)),
          ),
          new Container(
            padding: new EdgeInsets.only(bottom: 10),
          ),
          new TextButton.withTheme(
            onPressed: () => {},
            theme: Theme.of(context),
            child: new Text(
              FlutterI18n.translate(
                  context, "login.connect.connectPhoneNumber"),
            ),
            radius: 20,
            constraints: new BoxConstraints.tight(new Size(160, 40)),
            textStyle: Theme.of(context).textTheme.button,
          ),
        ],
      ),
    );
  }
}
