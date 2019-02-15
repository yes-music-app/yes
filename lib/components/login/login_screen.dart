import 'package:flutter/material.dart';
import 'package:yes_music/components/common/text_button.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color overlay = Theme.of(context).primaryColor.withAlpha(200);

    return new Container(
      decoration: BoxDecoration(
        image: new DecorationImage(
          fit: BoxFit.fitHeight,
          colorFilter: new ColorFilter.mode(overlay, BlendMode.multiply),
          image: new AssetImage("assets/login/background.png"),
        ),
      ),
      child: new Center(
        child: new TextButton.withTheme(
          onPressed: () => {},
          theme: Theme.of(context),
          radius: 20,
          padding: new EdgeInsets.all(20),
          child: new Text("hello world"),
        ),
      ),
    );
  }
}
