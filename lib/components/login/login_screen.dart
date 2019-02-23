import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/blocs/firebase_connect_bloc.dart';
import 'package:yes_music/components/common/custom_button.dart';
import 'package:yes_music/components/common/failed_alert.dart';
import 'package:yes_music/components/common/loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  FirebaseConnectBloc bloc;
  StreamSubscription subscription;

  @override
  void initState() {
    bloc = BlocProvider.of<FirebaseConnectBloc>(context);

    subscription = bloc.stream.listen((FirebaseAuthState state) {
      switch (state) {
        case FirebaseAuthState.UNAUTHORIZED:
          bloc.sink.add(FirebaseAuthState.AUTHORIZING_SILENTLY);
          break;
        case FirebaseAuthState.FAILED:
          showFailedAlert(
            context,
            FlutterI18n.translate(context, "login.failedInfo"),
            () => bloc.sink.add(FirebaseAuthState.UNAUTHORIZED_SILENTLY),
          );
          break;
        case FirebaseAuthState.AUTHORIZED:
          _pushChooseScreen(context);
          break;
        default:
          break;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color overlay = Theme.of(context).primaryColor.withAlpha(200);

    return new Container(
      decoration: _getBackground(overlay),
      child: new Center(
        child: new StreamBuilder(
          stream: bloc.stream,
          builder: (
            BuildContext context,
            AsyncSnapshot<FirebaseAuthState> snapshot,
          ) {
            if (snapshot == null || !snapshot.hasData) {
              return loadingIndicator();
            }

            switch (snapshot.data) {
              case FirebaseAuthState.UNAUTHORIZED_SILENTLY:
                return _getConnectButton(context, bloc);
              default:
                return loadingIndicator();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
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

  Widget _getConnectButton(BuildContext context, FirebaseConnectBloc bloc) {
    List<Widget> widgets = <Widget>[
      new Text(
        FlutterI18n.translate(context, "login.connectPrompt"),
        style: Theme.of(context).textTheme.headline,
      ),
      new Padding(
        padding: new EdgeInsets.only(bottom: 20),
      ),
      new CustomButton.withTheme(
        onPressed: () => bloc.sink.add(FirebaseAuthState.AUTHORIZING),
        theme: Theme.of(context),
        child: new Text(
          FlutterI18n.translate(context, "login.connectGoogle"),
        ),
        radius: 20,
        constraints: new BoxConstraints.tight(new Size(160, 40)),
      ),
    ];

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widgets,
    );
  }

  void _pushChooseScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed("/choose");
  }
}
